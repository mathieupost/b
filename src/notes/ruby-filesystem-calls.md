---
title: Ruby Filesystem Calls
date:  2017-03-30
...

If I run `bin/rake environment`{.bash} on Shopify/shopify right now, ruby executes 140737
filesystem-related syscalls. Many of these are clearly necessary, but many aren't. Let's go through
and identify some patterns that could maybe be optimized out.

I've generated the list of syscalls using [this dtrace
script](https://github.com/burke/dotfiles/blob/master/.config/dtrace/fs-access.d) and [this shell
script](https://github.com/burke/dotfiles/blob/master/bin/_git/dtrace-fs) (and invoked like
`dtrace-fs -o out -c 'ruby bin/rake environment'`{.bash}).

### Requiring files

First off, let's look at the work of actively loading a ruby source file once `bootsnap` is
loaded[^1]. Currently, this reads like:

```
open	/foo.rb
fstat64	/foo.rb
close	/foo.rb
open	/foo.rb
fstat64	/foo.rb
fgetxattr	/foo.rb
fgetxattr	/foo.rb
close	/foo.rb
```

With the work done [here](http://notes.burke.libbey.me/ruby-require-optimization/), this will look
like:

```
open	/foo.rb
fstat64	/foo.rb
fgetxattr	/foo.rb
fgetxattr	/foo.rb
close	/foo.rb
```

Since I haven't found a faster way of performing this work, I'll replace each occurrence of this
sequence of eight syscalls in the log with `%LOAD /path/to/file.rb`.

```ruby
HIT = %w(open fstat64 close open fstat64 fgetxattr fgetxattr close)
ls = STDIN.readlines.map { |l| l.chomp.split(/\t/) }
skip = 0
ls.each_cons(HIT.size) do |cs|
  if skip > 0
    skip -= 1
    next
  end
  if cs.map(&:first) == HIT && cs.map(&:last).uniq.size == 1
    skip = (HIT.size - 1)
    puts "%LOAD\t#{cs[0].last}"
  else
    puts cs[0].join("\t")
  end
end
ls[-(HIT.size - 1)..-1].each { |l| puts l.join("\t") }
```

This brings us to 5901 instances of `%LOAD` and 93529 other syscalls, for a total of 99430 lines.

### Loading YAML

Since `bootsnap` also caches YAML loads, but YAML loading doesn't go through ruby's file loading
mechanism, the pattern looks different:

```
open	/foo.yml
fstat64	/foo.yml
fgetxattr	/foo.yml
fgetxattr	/foo.yml
close	/foo.yml
```

Again, this isn't going to get a lot faster and it's a known quantity, so let's replace it too:

```ruby
HIT = %w(open fstat64 close open fstat64 fgetxattr fgetxattr close)
ls = STDIN.readlines.map { |l| l.chomp.split(/\t/) }
skip = 0
ls.each_cons(HIT.size) do |cs|
  if skip > 0
    skip -= 1
    next
  end
  if cs.map(&:first) == HIT && cs.map(&:last).uniq.size == 1
    skip = (HIT.size - 1)
    puts "%YAML\t#{cs[0].last}"
  else
    puts cs[0].join("\t")
  end
end
ls[-(HIT.size - 1)..-1].each { |l| puts l.join("\t") }
```

This results in 753 instances of `%YAML` and a total of 96418 lines.

### `rb_realpath_internal`

Ruby has a nasty habit of cascading a series of `lstat64` calls down the directory hierarchy each
time a file is loaded. We can see this here:

```
close	/opt/rubies/2.3.3/lib/ruby/site_ruby/2.3.0/rubygems/exceptions.rb
lstat64	/opt
lstat64	/opt/rubies
lstat64	/opt/rubies/2.3.3
lstat64	/opt/rubies/2.3.3/lib
lstat64	/opt/rubies/2.3.3/lib/ruby
lstat64	/opt/rubies/2.3.3/lib/ruby/site_ruby
lstat64	/opt/rubies/2.3.3/lib/ruby/site_ruby/2.3.0
lstat64	/opt/rubies/2.3.3/lib/ruby/site_ruby/2.3.0/rubygems
lstat64	/opt/rubies/2.3.3/lib/ruby/site_ruby/2.3.0/rubygems/exceptions.rb
```

Ruby is descending the hierarchy one call at a time, testing if each file is a symlink, right after
reading the file contents into a buffer. Conveniently, this path is not taken when
`RubyVM::InstructionSequence.load_iseq`{.ruby} returns a successful result, which it does in
essentially all cases after `bootsnap` is initialized.

Regardless, bootsnap isn't initialized before *everything* else, so we still see a number of these.
Let's replace them with `%RRPI` for `rb_realpath_internal`:

```ruby
ls = STDIN.readlines.map { |l| l.chomp.split(/\t/) }
prev = nil

one_path_component = ->(p) { !!(p =~ %r{^/[^/]+$}) }

flush = ->() {
  if prev
    puts "%RRPI\t#{prev}"
    prev = nil
  end
}

not_lstat = ->(l) {
  flush.()
  puts l.join("\t")
}

lstat = ->(l) {
  if prev
    if l[1].start_with?(prev) && one_path_component.(l[1][prev.size..-1])
      prev = l[1]
    else # lstat, but not part of this block.
      flush.()
      lstat.(l)
    end
  else
    if one_path_component.(l[1])
      prev = l[1]
    else
      not_lstat.(l)
    end
  end
}

ls.each { |l| l[0] == 'lstat64' ? lstat.(l) : not_lstat.(l) }
```

This gives us:

* 1192 instances of `%RRPI`;
* A reduction from 29063 to 17085 `lstat64` calls. Therefore, `rb_realpath_internal` generates:
    * 11978 `lstat64` calls;
    * 41% of all `lstat64` calls;
    * 8.5% of all filesystem-related syscalls.
* 85632 lines in our output file, of which:
    * 7846 are our `%X` markers;
    * 77786 are as-yet-unexplained.

One particularly hilarious outcome:

```
%RRPI	/path/to/bundler/gems/some-gem/.git/objects/bf
%RRPI	/path/to/bundler/gems/some-gem/.git/objects/c1
%RRPI	/path/to/bundler/gems/some-gem/.git/objects/c5
...(108 times)...
```

### `$LOAD_PATH` scans

Another common source of large sequences of syscalls is scanning the `$LOAD_PATH` (or
`ActiveSupport::Dependencies.autoload_paths`). This generates a sequence like:

```
open	/opt/rubies/2.3.3/lib/ruby/site_ruby/2.3.0/stringio.rb
open	/opt/rubies/2.3.3/lib/ruby/site_ruby/2.3.0/x86_64-darwin16/stringio.rb
open	/opt/rubies/2.3.3/lib/ruby/site_ruby/stringio.rb
open	/opt/rubies/2.3.3/lib/ruby/vendor_ruby/2.3.0/stringio.rb
open	/opt/rubies/2.3.3/lib/ruby/vendor_ruby/2.3.0/x86_64-darwin16/stringio.rb
```

Though we optimize most of these out using bootscale/bootsnap, there are still some paths that lead
to a path scan, and several that occur before bootsnap is initialized.

The identifiable pattern here is multiple calls to `open` where the final component of the path
stays the same but the prefix varies. Let's replace these with `%SCAN`:

```ruby
ls = STDIN.readlines.map { |l| l.chomp.split(/\t/) }
prev = nil
count = 0

push = ->(n) {
  prev = n
  count += 1
}

flush = ->() {
  if prev
    if count == 1
      puts "open\t#{prev}"
    else
      puts "%SCAN\t#{File.basename(prev)}"
    end
    prev = nil
    count = 0
  end
}

not_open = ->(l) {
  flush.()
  puts l.join("\t")
}

open = ->(l) {
  if prev
    if l[1].end_with?(File.basename(prev)) && l[1] != prev
      push.(l[1])
    else
      flush.()
      open.(l)
    end
  else
    push.(l[1])
  end
}

ls.each { |l| l[0] == 'open' ? open.(l) : not_open.(l) }
```

This gives us:

* 150 instances of `%SCAN`;
* A reduction from 13752 to 2137 unexplained `open` calls; therefore, `$LOAD_PATH` scans still
  account for:
    * 11615 `open` syscalls;
    * An average of 77 `open` calls per `$LOAD_PATH` scan;
    * 8.2% of all filesystem-related syscalls.
* 74167 lines in our output file, of which:
    * 7996 are our `%X` markers;
    * 66171 are as-yet-unexplained.

### Death by a million `stat`s

It's fairly apparent looking at the log now that we spend a lot of time `stat`-ing files. Of 66171
unexplained syscalls:

* 39976 *(60%)* are `stat64`;
* 17085 *(26%)* are `lstat64`;
* 1571 *(2%)* are `fstat64`.

This totals 58632 of 66171 -- 89% of all unexplained syscalls are `stat` operations.

Here's a breakdown of the remaining syscalls:

```
$ grep -v 'stat64' outp4 \
  | grep -v -E '^%' \
  | awk -F "\t" '{ a[$1]++ } END { for (c in a) print a[c] "\t" c; }' \
  | sort -nr
2719    read
2387    close
2137    open
141     pread
124     write
14      fgetxattr
11      socket
5       mkdir
1       shm_open
```

Of these:

* Most of the `read`, `open`, and `close` will be from loading ruby files before initializing `bootsnap`;
* Most of the `pread` will be from loading native extensions;
* Write is all logs and stdout/stderr;
* The rest are all really small numbers.

### `stat64` path scans

I see a pattern where we're doing this across the `ActiveSupport::Dependencies.autoload_paths`{.ruby}:

```
stat64	(some gem)/app/assets/teaspoon/bundle/bundle_helper.rb
stat64	(some gem)/app/controllers/teaspoon/bundle/bundle_helper.rb
stat64	(some gem)app/assets/teaspoon/bundle/bundle_helper.rb
```

Let's replace these scans with `%ASDS` for "ActiveSupport Dependencies Scan":

```ruby
ls = STDIN.readlines.map { |l| l.chomp.split(/\t/) }
prev = nil
count = 0

push = ->(n) {
  prev = n
  count += 1
}

flush = ->() {
  if prev
    if count == 1
      puts "stat64\t#{prev}"
    else
      puts "%ASDS\t#{File.basename(prev)}\t#{count}"
    end
    prev = nil
    count = 0
  end
}

not_stat64 = ->(l) {
  flush.()
  puts l.join("\t")
}

stat64 = ->(l) {
  if prev
    if File.basename(l[1]) == File.basename(prev) && l[1] != prev
      push.(l[1])
    else
      flush.()
      stat64.(l)
    end
  else
    push.(l[1])
  end
}

ls.each { |l| l[0] == 'stat64' ? stat64.(l) : not_stat64.(l) }
```

This gives us:

* 786 instances of `%ASDS`;
* A reduction from 39979 to 34650 unexplained `stat64` calls; therefore, these scans account for:
    * 5329 `stat64` syscalls;
    * An average of 7.5 `stat64` calls per scan *(why so low, on a 500+ item path?)*;
    * 13% of unexplained `stat64` calls.
* 69627 lines in our output file, of which:
    * 8782 are our `%X` markers;
    * 60845 are as-yet-unexplained.

It seems puzzling that, on a 500+ item path, the average number of calls is only 10. Apparently my
assumption that this is all `ActiveSupport::Dependencies.autoload_paths`{.ruby} was not correct.
Let's dig in to this more. A histogram of the number of items scanned for each occurrence:

```bash
grep '%ASDS' out \
  | awk '{ a[$3] += 1 } END { for (c in a) print c, "\t", a[c] }' \
  | sort -n
```

```gnuplot
set terminal svg size 770,200 fname 'Helvetica'
set style fill transparent solid 0.5 noborder
set xlabel "syscalls per scan (log)"
set ylabel "scans (log)"
set logscale xy
set grid
set boxwidth 0.05 absolute
plot "-" using 1:2 with boxes lc rgb"green" notitle
2        714
3        20
4        7
5        4
6        5
7        5
8        2
9        1
10       2
11       1
12       1
13       1
14       5
15       2
19       1
24       1
27       1
35       4
41       1
59       1
248      1
284      1
540      3
541      2
```

So really, the number of full scans of `ActiveSupport::Dependencies.autoload_paths`{.ruby} is
quite small (fewer than ten). The majority of these seem to involve fewer than ten syscalls.

There are clearly two problems here:

#. Path scans;
#. Individual files being `stat`'ed twice for no apparent reason.

### `stat64`+`lstat64`

An extremely common pattern is to `stat64` and then immediately `lstat64` a file. This feels
wasteful[^2]. Let's label these occurrences as `%STLS`:

```ruby
ls = STDIN.readlines.map { |l| l.chomp.split(/\t/) }
stat = nil

flush = ->() {
  if stat
    puts "stat64\t#{stat}"
    stat = nil
  end
}

ls.each do |l|
  if l[0] == 'stat64'
    flush.()
    stat = l[1]
    next
  end

  if l[0] == 'lstat64' && l[1] == stat
    puts "%STLS\t#{l[1]}"
    stat = nil
    next
  end

  flush.()
  puts l.join("\t")
end
```

This gives us:

* 7359 instances of `%STLS`;
* A reduction from 39979 to 34650 unexplained `stat64` calls; therefore, these scans account for:
    * 7359 definitely-useless `lstat64` calls.
    * A 43% reduction in unexplained `lstat64` calls if fixed;
    * A 13% reduction in  unexplained `*stat64` calls if fixed.
* 62268 lines in our output file, of which:
    * 16141 are our `%X` markers;
    * 46127 are as-yet-unexplained.

### recursively `stat`'ing gems

Of the remaining `stat64` calls, a majority appear to iterating through the contents of a gem. The pattern appears like this:

```
stat64	CHANGELOG
stat64	CONTRIBUTORS
stat64	MIT-LICENSE
stat64	README.md
stat64	README.md
stat64	lib/active_merchant
stat64	lib/active_merchant.rb
stat64	lib/active_merchant/billing
stat64	lib/active_merchant/billing.rb
```

This is a little harder to detect since ruby `chdir`s into the gem before scanning and I didn't
bother to capture the directory in my output. Still, we can probably do a reasonable heuristic job.

We're going to reorder our replacements though, because this will capture some uses of `%ASDS` and
`%STLS`:

* `%LOAD`
* `%YAML`
* `%RRPI`
* `%SCAN`
* `%SGEM` *(new)*
* `%ASDS`
* `%STLS`

```ruby
ls = STDIN.readlines.map { |l| l.chomp.split(/\t/) }

in_stat_chunk = false
in_stat_chunk_which_is_a_gem = false
past_toplevel_within_gem = false
buf_lines = []

flush = ->() {
  if buf_lines.size > 8
    puts "%SGEM\t(some-gem)\t#{buf_lines.size}"
  else
    buf_lines.each do |l|
      puts l.join("\t")
    end
  end
  in_stat_chunk = false
  in_stat_chunk_which_is_a_gem = false
  past_toplevel_within_gem = false
  buf_lines = []
}

push = ->(l) {
  buf_lines << l
}

EXCLUDES = %w(config csv fonts images javascsripts stylesheets svg)

handle_stat = ->(l) {
  at_toplevel = l[1].count('/').zero?

  if !in_stat_chunk
    in_stat_chunk = true
    in_stat_chunk_which_is_a_gem = at_toplevel && !EXCLUDES.include?(l[1])
  end

  if !at_toplevel
    past_toplevel_within_gem = true
  end

  # Looks like a new gem?
  if past_toplevel_within_gem && at_toplevel
    flush.()
    return handle_stat.(l)
  end

  if in_stat_chunk_which_is_a_gem
    push.(l)
  else
    puts l.join("\t")
  end
}

ls.each do |l|
  unless 'stat64' == l[0] || 'lstat64' == l[0]
    flush.()
    puts l.join("\t")
    next
  end

  handle_stat.(l)
end
```

Having not reapplied `%ASDS` or `%STLS` yet, we get:

* 450 instances of `%SGEM`;
* A reduction from from 58631 to 14863 (by 74%) unexplained `*stat64` calls;
* 30848 lines in our output file, of which:
    * 8446 are our `%X` markers;
    * 22402 are as-yet-unexplained.

Replaying `%ASDS` and `%STLS`, we get:

* 221 instances of `%ASDS`;
* 129 instances of `%STLS` *(interesting that this was primarily used in gem scans)*;
* 26817 lines in our output file, of which:
    * 8796 are our `%X` markers;
    * 18021 are as-yet-unexplained.

Generating the histogram of `%ASDS` stat count again, we get:


```gnuplot
set terminal svg size 770,200 fname 'Helvetica'
set style fill transparent solid 0.5 noborder
set xlabel "syscalls per scan (log)"
set ylabel "scans (log)"
set logscale xy
set grid
set boxwidth 0.05 absolute
plot "-" using 1:2 with boxes lc rgb"green" notitle
2        171
3        12
4        2
5        2
6        4
7        4
9        1
11       1
12       1
13       1
14       4
15       2
19       1
24       1
27       1
35       4
41       1
59       1
248      1
284      1
540      3
541      2
```

The main difference here is that the number of 2s dropped quite a lot. I guess most of those were
occurring in those gem scans.

### Miscellaneous Observations

* There are a lot of lines dealing with gemspecs. We spend 500 lines `lstat64`'ing gemspecs, then
  1500 `open`+`read`+`close`-ing them. This accounts for 11% of unexplained calls.
* We burn 450 calls loading `did_you_mean` (2%);
* We appear to do the same 2000 calls to `lstat64` and then `open`+`read`+`close` all the gemspecs
  again after loading bundler (another 11%, totalling 22%);
* A relatively large proportion of "unexplained" remaining calls is just a pattern of
  `open`+`fstat64`+`close`+`open`+`fstat64`+`fstat64`+`read`$\times n$ +`close` calls from before
  initializing bootsnap;
* `%SCAN` seems to have maybe eaten the syscall immediately following it?;
  3400 `stat64` operations are spent on regenerating `bootsnap`'s load path cache for volatile
  entries (19%).

Excluding the regular ruby require path, which is hard to measure just with `grep` and `wc`, these
account for 7850, or 44% of remaining calls, bringing the number of mystery-calls down to about
10000, out of a total 140737.

[^1]: bootsnap is a combination of [aot_compile_cache](https://github.com/shopify/aot_compile_cache)
and other work based on [bootscale](https://github.com/byroot/bootscale) that isn't public yet but
likely will be soon.

[^2]: At the very least, we should be able to use `lstat64` first and use `S_ISLNK` to run the
`stat64` if and only if the file is actually a symlink.
