---
title: Image Distribution
date: 2018-11-08
toc: false
...

I don't like the way Docker stores and distributes images, for several reasons:

* The graph repository is confusing and extremely difficult to interact with without the aid of docker itself;
* The storage format is different from the wire format;
* Layers are baked into the storage format, rather than being constructed at container boot;
* Transport and decompression are slow, because they are mandatorily mediated by the docker daemon,
  which has not optimized these paths, nor made it easy to work around them.

Other container systems do better on this front but don't make much attempt to solve the image
distribution problem.

What follows is a basic sketch of a container image format with efficient incremental distribution
and none of the properties I complained about above.

### Image Format

Images should be [SquashFS](https://en.wikipedia.org/wiki/SquashFS). That's it. This is a solved
problem. You don't need to unpack SquashFS; you just mount it. It's read-only.

Configuration (environment, entrypoint, etc.) could live inside the image. Perhaps there could be
two top-level nodes:

* `config.json`, containing whatever settings;
* `root/*`, containing the full image filesystem.

### Read-Write Support

[Overlay](https://en.wikipedia.org/wiki/OverlayFS). Mount the SquashFS read-only, then mount
a read-write overlay on top. The container can be started using this overlay as the filesystem root.

### Distribution

Since SquashFS can be mounted directly, all you need to do is download a file and run it. However,
downloading a marginally-changed new revision of an image results in a full re-download. We can
solve this by diffing the two versions and generating a binary diff.

In the past, I've used [xdelta3](https://en.wikipedia.org/wiki/Xdelta) for this.
[bsdiff](http://www.daemonology.net/bsdiff/) is another option. However, both of these are slow: far
to slow to generate on-the-fly in response to a client request.

A more timely way to do differential distribution would be to read both SquashFS files and generate
a list of files changed between them, generating a file containing all of the changed files. Moved
could be accounted for by taking a sum of the contents of each file as well. An old library
I wrote—[treediff](https://github.com/burke/treediff)—could be a starting point for this.

With a properly SquashFS-aware diff library, it should be feasible to have a repository server
respond to requests for an image diff given a target image and a reference image, already possessed,
and generate the diffs inline (ideally with caching).

### Summary

* SquashFS
* Overlay
* Binary Diff, but for practicality, we'd need a SquashFS-aware diff.
