---
title: Deepfake Mitigation
date: 2018-11-08
...

For the past year or so, smart twitter people have been publicly worrying about the political impact
of [Deepfakes](https://en.wikipedia.org/wiki/Deepfake), where a video is altered (or fabricated from
nearly whole cloth), that shows events that didn't happen, or didn't happen the way they were
portrayed. The most major source of concern, for me, is that a video can be shared with a watermark
from a trusted source, but be a modified version of the video originally shown by that trusted
source (e.g. news agency).

This is a scheme that could defend against this sort of behaviour by authenticating videos as
originating with a known source, even after being transcoded, maybe even embedded in some other
video, or so forth.

1. Break video into ~1s chunks
2. Take a perceptual hash of each chunk (e.g. [phash](https://www.phash.org/download/) or
   [blockhash](http://blockhash.io/))
3. For each chunk, concatenate the current hash and the previous 5-10
4. Sign this collection of hashes with a known private key registered to your news agency (maybe
   a CA structure)
5. Embed this signature as side-band data in the video stream *(Or, you know, you could sprinkle blockchain fairy dust on it)*.

Then, in playback:

1. For each segment of video, calculate the same perceptual hash of what's being displayed;
2. Verify the embedded signature against the calculated hashes;
3. Display a watermark on the video (ideally in the window chrome, so that the video can't fake this
   in-band) indicating a positive authentication;
4. If the authentication fails, change the watermark to an extremely scary looking red thing.

This scheme or some variation on it should, in theory, be resilient to:

* Transcoding;
* Sampling portions of the video;
* Embbedding within another video, by encoding a viewport rectangle.

Any other modification, such as speeding the video up, changing the words, cutting out small
sections, etc., should all fail the hash and display a warning to the user.
