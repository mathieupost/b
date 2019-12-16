---
title: Debugging a Nix Build Failure
date: 2019-01-24
toc: false
...

I'm new to [Nix](https://nixos.org). I'm experimenting with moving a bunch of
development environments to Nix. Part of that is rubygems, for which we're using
[`bundix`](https://github.com/manveru/bundix).

Yesterday, after I [taught Bundix how to fetch gems from a private
gemserver](https://github.com/manveru/bundix/pull/40), I ran into a compile
error on one gem ([gctrack](https://rubygems.org/gems/gctrack/versions/0.1.0)).
Here's the especially-relevant part of the error:

```
compiling gctrack.c
gctrack.c:26:7: warning: implicit declaration of function 'clock_gettime' is invalid in C99 [-Wimplicit-function-declaration]
  if (clock_gettime(CLOCK_MONOTONIC, &ts) == -1) {
      ^
gctrack.c:26:21: error: use of undeclared identifier 'CLOCK_MONOTONIC'
  if (clock_gettime(CLOCK_MONOTONIC, &ts) == -1) {
                    ^
1 warning and 1 error generated.
make: *** [Makefile:242: gctrack.o] Error 1
```

I found [this issue on nixpkgs](https://github.com/NixOS/nixpkgs/issues/28997)
that describes pretty well this exact issue, but without resolution. I'm not
sure I'm going to be able to fix this, but I'll at least document here my
attempt to get to the root cause.

### Minimal reproduction

##### `default.nix`

```nixpkgs
with import <nixpkgs>{};
let
  gems = bundlerEnv {
    name = "shopify";
    ruby = ruby_2_5;
    # nix doesn't really parse these so I'm cheating for this example.
    gemfile = ./gemset.nix;
    lockfile = ./gemset.nix;
    gemset = ./gemset.nix;
  };
in
stdenv.mkDerivation rec {
  name = "shopify";
  buildInputs = [ gems ];
}
```

##### `gemset.nix`

```nixpkgs
{
  gctrack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sn5f753lff1kap8dg3msf920p6cnm75q83i7929k3jvqdjzmz0d";
      type = "gem";
    };
    version = "0.1.0";
  };
}
```

Success (or failure): running `nix-shell .` gives me the same failure. Now I
want to get `bundlerEnv` out of the way and get `gemset.nix` integrated into
`default.nix` somehow.

I cloned [`nixpkgs`](https://github.com/NixOS/nigpkgs) and searched it for
"bundlerEnv =", and got:

```
pkgs/top-level/all-packages.nix
8069:  bundlerEnv = callPackage ../development/ruby-modules/bundler-env { };
```

This points to
[.../bundler-env/default.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/bundler-env/default.nix).
At a really quick read, it kind of looks like it's just a wrapper around
`basicEnv`, but that doesn't exist in the top-level namespace so I'm not totally
sure how to get at it. Still, I can see that `basicEnv` comes from
[`bundled-common`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/bundled-common/default.nix).

Looking at this file, I don't see a super easy way to hook into this, or any
obvious place that I might want to, but I do spot a function call that seems
interesting:

```
buildGem = name: attrs: (
  let
    gemAttrs = composeGemAttrs ruby gems name attrs;
  in
  if gemAttrs.type == "path" then
    pathDerivation (gemAttrs.source // gemAttrs)
  else
    buildRubyGem gemAttrs # <---- this
);

```

...and searching the top-level does actually turn something up:

```
$ ag 'buildRubyGem =' pkgs/top-level
pkgs/top-level/all-packages.nix
8065:  buildRubyGem = callPackage ../development/ruby-modules/gem { };
```

There must be a nix command for this. It seemed like `nix-env` might work but I guess `buildRubyGem` isn't a derivation:

```
$ nix-env -qaPA nixpkgs.firefox
nixpkgs.firefox  Firefox-64.0.2
$ nix-env -qaPA nixpkgs.buildRubyGem
error: expression does not evaluate to a derivation (or a set or list of those)
```

Alright, [this is looking like where the gem install is actually
happening](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem/default.nix).

I guess what I'd really like to be able to do here is:

1. Capture all of the attributes passed to this derivation when I try to build it via `bundlerEnv`; and/or
2. Figure out how to call it directly from my `default.nix`.

For the latter, the gem build is actually its own derivation, so we can just
extract it from the store. From the error output:

```
builder for '/nix/store/nlrp8pbf0y32zp63hbi5k9s0fhiwqrag-ruby2.5.3-gctrack-0.1.0.drv' failed with exit code 1
```

If I `cat $that_file`, I get... a technically-readable but kinda difficult mess.
I think I remember there being a command for this, and found it:

```
$ nix show-derivation /nix/store/nlrp8pbf0y32zp63hbi5k9s0fhiwqrag-ruby2.5.3-gctrack-0.1.0.drv
```

This actually looks useful: <https://gist.github.com/burke/a1f1f5838691d4e221027ff4113662ea>

So this is an interesting thing to realize a little quicker next time: I can get
closer to the root of a failure by just checking the log for the actual
derivation path that failed.

I understand from that GitHub issue way back that the issue has something to do
with the impurely-sourced `libSystem`, which I can see in the derivation:

```
"__impureHostDeps": "/bin/sh /usr/lib/libSystem.B.dylib ...",
```

And finally I can sort-of-minimally reproduce that error by running:

```
nix-build /nix/store/nlrp8pbf0y32zp63hbi5k9s0fhiwqrag-ruby2.5.3-gctrack-0.1.0.drv
```

So that issue mentioned that it's a mismatch between `libSystem` and whatever
headers are available. If we have the library available as an impure input, we
probably need some sort of explicit `buildInput` for the headers, and we don't seem to:

```
nix show-derivation /nix/store/<hash>-ruby2.5.3-gctrack-0.1.0.drv| grep uildInputs
deactivated shadowenv.
      "buildInputs": "...-ruby-2.5.3 ...-hook ...-objc4-osx-10.11.6",
      "nativeBuildInputs": "",
      "propagatedBuildInputs": "",
      "propagatedNativeBuildInputs": "",
```

I'm spending some time googling and whatnot to see if I can figure out what's missing...
