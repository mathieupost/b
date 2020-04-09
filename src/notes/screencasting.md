---
title: Screencasting
date: 2020-04-09
toc: false
...

This year I've made it my mission to radiate a bunch of knowledge about Nix within my company, and
with the whole world (certainly my whole company) moving to remote work this year, the format I've
chosen is screencasting. This document describes all of the specifics of how I make them, just so I
can reference it when people ask.

This is descriptive, not normative: there are probably lots of things you can do better if you're
looking to make screencasts too.

## Hardware

* Microphone: [Blue Yeticaster](https://www.bluedesigns.com/products/yeticaster/) with some random
off-brand pop filter.
* Camera: [Canon Rebel
T6s](https://www.canon.ca/en/product?name=EOS_Rebel_T6s&category=/en/products/Cameras/DSLR-Cameras/Entry-level),
propped on a [cheap little shelf](https://www.umbra.com/products/showcase-floating-shelf-set-of-3) with the lens at about nose height
(This would be the thing I would change if I was looking to spend more money: the live video quality
is sort of mediocre).
* Lens: [Canon EF-S 24mm f/2.8
STM](https://www.google.com/search?q=canon+24mm+ef-2+2.8+stm&oq=canon+24mm+ef-2+2.8+stm&aqs=chrome..69i57.10352j0j1&sourceid=chrome&ie=UTF-8)
* Lighting: [Koncept Z-Bar task lamp](https://www.koncept.com/Z-Bar), generally turned up to max and
pointed at the wall behind the camera

## Software

* [Camera Live](https://github.com/v002/v002-Camera-Live)
* [CamTwist](http://camtwiststudio.com/)
* [ScreenFlow](https://www.telestream.net/screenflow/overview.htm)

## Configuration

* Record at 1920x1080
* Use iTerm2 and create a profile for screencasting:
  * I set the Command on Profile>General>Command to `/usr/bin/env SCREENCAST=1
  /run/current-system/sw/bin/zsh`, and changed `HISTFILE` to a tempfile so that my shell completions
  don't bleed over into the screencast.
  * I use PragmataPro Mono Liga at 28pt regular, anti-aliased and with ligatures.
  * I use [this
  colorscheme](https://s3.amazonaws.com/burkelibbey/maybe-gruvbox-but-dunno.itermcolors)
  * With my font and font size, a 135x33 window fits nicely in 1920x1080
* Configure Camera Live or CamTwist or whatever to capture video at 30fps at 1920x1080 (this is the
highest my camera does).
* Open a browser window with margins just inside the terminal

## Production

* Hit "Configure Recording" in Screenflow and select a 1920x1080 box around your terminal. Ideally
put it as near to your camera as possible.
* I add a black 0º, 0/70%/9 drop shadow to my camera video.
* For the intro and outro, I have my camera video at 65% zoom, x=0;y=0
* While we're looking at the screen, I move the camera to 25% zoom, x=692;y=-378, unless I need to
dodge it to see behind, in which case I prefer to move it to x=-692;y=-378.

## Thumbnails

* From ScreenFlow, hit "Save Frame" on some point in the video, drag this into Pixelmator Pro (or
whatever)
* Add a 50% opacity black layer in front
* Add centered text in Philosopher Regular 200pt at #3778B7 with your video title
* Monospace typeface: Pragmata Pro Mono Liga Regular 200pt at #7EB4DF.

## Youtube

* Upload the videos as unlisted
* Create an unlisted playlist and add the videos to them
* Verify your account and drag in thumbnails

## Posting in Slack

:youtube-video: and :youtube-playlist: are probably-useful emoji for this. You can link to a video
*in* a playlist, which is probably the video link you should use if you're publishing multiple.
