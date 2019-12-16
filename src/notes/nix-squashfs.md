---
title: Nix, Containerization, and SquashFS
date:  2019-08-19
...

Here's a random idea of indeterminate worth:

Nix store entries are read-only. It would be possible to store each entry as a SquashFS file.

Nix store entries are content-addressable and could be stored on a SAN.

The full dependency closure of each nix store entry is known when it is created, and this full list
could be stored alongside the nix store.

In order to start a containerized version of some nix derivation, we could imagine looking up the
dependency closure for that entry from a SAN and mounting each SquashFS involved in that closure
into a workspace, then starting an otherwise-empty container on top of that workspace with some
entrypoint given by configuration or convention.

This could have some interesting properties as far as container image build and distribution times
go, and security people would probably enjoy the transparency. There are a lot of other interesting
consequences that I haven't really thought through.
