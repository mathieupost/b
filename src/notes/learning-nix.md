---
title: Learning Nix
date: 2018-12-17
toc: false
subtitle: "(WIP as of 2018-12-17: Updated as I go)"
...

I'm learning learning to use Nix. This page lists the resources I used, in the
order I used them. I feel pretty good about this as a reasonable strategy (for
me, at least!) to get up and running.

1. Install nix on macOS.
1. Read through `man nix-env` and play around with most of the options. Skim the other `man nix-*`
   to get a basic feel.
1. semi-concurrently with above, dig through `~/.nix-profile`, `~/.nix-channels`, `~/.nix-defexpr`,
   and `/nix/var/nix/profiles`, to start building a mental model of how all these things interact.
1. Complete <https://nixcloud.io/tour/>. If you haven't mucked around with functional languages
   much, the last handful of exercises might break your brain, but I don't think that sort of thing
   is going to come up very often in real use.
1. Set up a NixOS box on DigitalOcean (<https://chris-martin.org/2016/nixos-on-digitalocean>). 1GB
   of RAM isn't enough for some operations, 4GB is plenty. Play around with NixOS a bit.
1. Read through <https://nixos.org/nixos/nix-pills/>. The last 2-3 start to get kind of... arcane.
   I started skimming at that point.
1. <https://nixos.org/nix/manual/>. A lot is skimmable at this point; new/interesting stuff in
   Chapter 13; reference parts (15, 21) later on worth a skim just to get an idea of what exists.

Current project:

1. Clone <https://github.com/NixOS/nixpkgs>, and start exploring. Start with `default.nix` and keep
   going until you have a rough idea of how to navigate the whole codebase.

Haven't looked at yet, but probably worth reading:

* <https://nixos.org/nixos/manual/>
* <https://nixos.org/nixpkgs/manual/>
* <https://nixos.org/~eelco/pubs/phd-thesis.pdf>
* <https://nixos.wiki>
* <https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/setup.sh>
