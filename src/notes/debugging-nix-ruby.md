---
title: Debugging a Gem version issue in Nix
date: 2020-06-02
toc: false
...

A user pointed this out, and I realized I'm getting the same thing: When I try to do anything in
Core that loads the bundle, I get this:

```
https://github.com/rails/rails.git (at master@a47e0c1) is not yet checked out. Run `bundle install` first.
```

Switching to various versions of core and `dev` from the past two weeks (then rerunning `dev up`)
doesn't seem to solve the issue.

Manually clobbering and regenerating the shadowenv doesn't solve the issue, nor does restarting my
shell.

Digging into the `BUNDLE_PATH`, I notice:

```
$ ls $BUNDLE_PATH/bundler/gems | grep rails-
rails-cdbce035a5b0/
```

Meanwhile, this is not the version specified by the Gemfile.lock:

```
$ grep -A1 rails/rails Gemfile.lock
  remote: https://github.com/rails/rails.git
  revision: a47e0c19e60b17c3d0dcae240ef85de52113ea57
```

So, what's actually happening here is that the bundle contains the wrong version of rails! Let's
find the Nix store path of that output:

```
$ nix-store -qR $DEV_PROFILE | grep cdbce
/nix/store/dribkna63fjlimqln6r0wzn9q6rliqj2-rails-cdbce03
```

And then figure out the dependency path that led to it getting included:

```
$ nix why-depends $DEV_PROFILE /nix/store/dribkna63fjlimqln6r0wzn9q6rliqj2-rails-cdbce03
/nix/store/43gfy33jxva6kdj7mzrsxgvs0zsbj0w8-shadowenv-ruby-env-shopify
╚═══nix-support/shadow.lisp: …")..; generated from /nix/store/6cvzpz3k9y6p5ymsws99nzf08qzxh0jm-gem-bundle-shopify/nix-support/…
    => /nix/store/6cvzpz3k9y6p5ymsws99nzf08qzxh0jm-gem-bundle-shopify
    ╚═══lib/ruby/gems/2.7.0/bin/rails -> /nix/store/5468x4qkgvqhbxngpvqwjsfs2fa5dzsa-ruby2.7.1-railties-6.1.0.alpha/lib/ruby/gems/2.7.0/bin/rails
        => /nix/store/5468x4qkgvqhbxngpvqwjsfs2fa5dzsa-ruby2.7.1-railties-6.1.0.alpha
        ╚═══lib/ruby/gems/2.7.0/bundler/gems/rails-cdbce035a5b0 -> /nix/store/dribkna63fjlimqln6r0wzn9q6rliqj2-rails-cdbce03
            => /nix/store/dribkna63fjlimqln6r0wzn9q6rliqj2-rails-cdbce03
```

Let's tidy that up to make it more readable...

```
$ nix why-depends $DEV_PROFILE /nix/store/dribkna63fjlimqln6r0wzn9q6rliqj2-rails-cdbce03
(shadowenv-ruby-env-shopify)
╚═══nix-support/shadow.lisp: …")..; generated from (gem-bundle-shopify)/nix-support/setup-hook
    => (gem-bundle-shopify)
    ╚═══lib/ruby/gems/2.7.0/bin/rails -> (ruby2.7.1-railties-6.1.0.alpha)/lib/ruby/gems/2.7.0/bin/rails
        => (ruby2.7.1-railties-6.1.0.alpha)
        ╚═══lib/ruby/gems/2.7.0/bundler/gems/rails-cdbce035a5b0 -> (rails-cdbce03)
            => (rails-cdbce03)
```

`shadowenv-ruby-env-shopify` -> `gem-bundle-shopify` -> `ruby2.7.1-railties-6.1.0.alpha` ->
`rails-cdbce03`.

So, since the `Gemfile.lock` has a different version, one of these links is doing something wrong.

My first thought from this point is, let's find the thing that's actually consuming a Gemfile.lock
to build the bundle.

So let's find the lockfile(s!) used to construct this:

```
$ nix-store --query --requisites $(nix-store --query --deriver $DEV_PROFILE) | grep gemfile-and-lockfile
/nix/store/j59wxgq3rd3jh02n5fslc65lm1qkl8f0-gemfile-and-lockfile.drv
/nix/store/g9n53dg0q197vpxr777236wvlzvmhky3-gemfile-and-lockfile.drv
```

Two of them!

```
$ nix show-derivation /nix/store/j59wxgq3rd3jh02n5fslc65lm1qkl8f0-gemfile-and-lockfile.drv | jq -r '.[].inputSrcs[]' | grep lock
/nix/store/12hnhzrficsggsz6c57kzsw2cflh3xch-Gemfile.lock
$ nix show-derivation /nix/store/g9n53dg0q197vpxr777236wvlzvmhky3-gemfile-and-lockfile.drv | jq -r '.[].inputSrcs[]' | grep lock
/nix/store/nv9qiah5wvvqwh8yc5yjbnhz36ysn84x-Gemfile.lock
```

Ok, well it turns out one of those only contains `rake` and must be for some internal tooling thing
(probably just packaging `bundler`), but the other one:

```
grep -A1 rails/rails /nix/store/nv9qiah5wvvqwh8yc5yjbnhz36ysn84x-Gemfile.lock
  remote: https://github.com/rails/rails.git
  revision: cdbce035a5b0ebc779dd445888ab5670f945603c
```

We wanted `a47*`, but got `cdb*`! This _should_ be fixed automatically for us when we run `dev up`,
but it doesn't seem to be. How is this not busting the cache?

I'm going to try adding a blank line to the `Gemfile.lock` to see if that triggers a rebuild, but
first, I'm going to back up `.dev/nix-profile` and `.shadowenv.d` so that I can trivially restore
the broken state if that fixes it.

```
$ mkdir bak; mv .dev/nix-profile .shadowenv.d bak
$ echo >> Gemfile.lock
$ dev up
```

Interestingly, the build widget doesn't seem to be aware of the build as it's happening (nothing
active in the "in progress" field, probably due to output format changes in the latest Nix version
that we haven't updated the state machine for yet, but unrelated). However, the debug logs indicate
that it did build a new gem bundle.

As expected, now, we get `a47*`:

```
ls $BUNDLE_PATH/bundler/gems | grep rails-
rails-a47e0c19e60b/
```

So, the problem seems to be that Nix isn't detecting the `Gemfile.lock` change. Is this an mtime
issue? Maybe it's not actually checksumming files from local paths to determine whether there's work
to do.

Let's restore the broken state and try again:

```
$ rm -r .dev/nix-profile .shadowenv.d
deactivated shadowenv
run dev up to generate this project's shadowenv.
$ cp -a bak/.shadowenv.d .
activated shadowenv (node:v8.12.0, ruby:2.7.1)
$ cp -a bak/nix-profile .dev
$ git checkout Gemfile.lock
```

Now, what does `dev up` do?

```
$ dev up
(...output...)
$ ls $BUNDLE_PATH/bundler/gems | grep rails-
rails-a47e0c19e60b/
```

That is highly curious. This should be the same state as before, other than that the times of the
`Gemfile.lock` have now been bumped.

(...wip, still debugging...)
