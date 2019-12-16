---
title: How I Read
date: 2018-10-17
toc: false
...

*(last updated 2019-02-22)*

I don't remember the exact sequence of events, but a couple of months ago, I became aware of:

* [How I Read by Simon Eskildsen](https://sirupsen.com/read/);
* [Readwise](https://readwise.io); and
* [How to Actually Use What You Read with Readwise](https://blog.readwise.io/reading-workflow-part-1/).

For years, I've liked the idea of being able to easily mark passages in books I read and have them
trivially resurfaced later, but Kindle's locked-down ecosystem has made this difficult. When I came
across Readwise, and read the other two articles above, I was suddenly motivated to build a better
reading workflow of my own.

[According to Readwise](https://blog.readwise.io/reading-workflow-part-1/), there are three
fundamental steps in any good reading workflow: **Capture**, **Review**, and **Integrate**. Simon breaks
this down differently, but the Readwise categorization resonates better with me. So here's my
reading workflow, phase-by-phase:

## Overview

**Capture**:
Read in Kindle, Instapaper, dead-tree books, or PDF. In all but the latter case, use Readwise to
aggregate. In the case of PDF, a custom script rips annotations from PDFs in a special location in
my iCloud Drive.

**Review**:
For physical books, use OCR and paste into Readwise's manual entry. Mass-export data from Readwise.
Import this, as well as the PDF export, into [Anki](https://apps.ankiweb.net), with a special note
type and template. Review these daily.

**Integrate**: When I encounter a highlight with information that I'd like to remember more
explicitly, I use Anki's "mark" feature. Periodically, I work through Marked items and convert them
into fine-grained question-and-answer cards in Anki, then suspend the Highlight note.

## Capture

In the Capture phase, I'm concerned with capturing highlights with the lowest overhead possible.
Source by source:

**Kindle**: Just highlight.

**Instapaper**:
If I'm reading something on the web longer than a few paragraphs, I generally send it to Instapaper
and read it there, highlighting anything that I'd like to be reminded of.

**PDF**:
I save these to a directory named "Highlighted PDFs" in my iCloud Drive, then (on iOS) open them
from the "Files" app. Unlike iBooks on iOS, Files supports highlighting and annotating.

**Physical Books**:
Generally I just draw a line in the margin next to the interesting part, then scribble a bit on the
lower right corner of the right page. This makes flipping through to find all the marked up pages
much easier later on.

## Review

The meat of my "Review" phase is simply opening Anki every day and reading a group of highlights,
presented at increasing intervals using [Spaced
Repetition](https://en.wikipedia.org/wiki/Spaced_repetition), but there's some menial labour I have
to do when adding new highlights before I can do that. Again, this part is broken down by format.

**Kindle**:
Readwise can import highlights from Kindle, but it requires me to actually open a browser window so
that they can scrape the Kindle site using a browser plugin. I run this each time I've created new
Kindle highlights, then I run a script "`kindle2anki`" which downloads all of my Readwise highlights
and imports them into Anki (more detail on this shortly).

**Instapaper**:
Readwise automatically synchronizes Instapaper highlights, and my same script reimports them to
Anki.

**PDF**:
I wrote another script that extracts highlights from all of the PDFs in this special iCloud Drive
directory that I save them to. The output of this script is also picked up by my Anki import script.
I don't use this as often and I'm still ironing out bugs pretty much every time I use it.

**Physical Books**:
I use the Readwise "Freeform Input" feature, but I sometimes OCR the text rather than typing it,
using an App called [CamScanner](https://itunes.apple.com/ca/app/camscanner/id388627783?mt=8). Once
again, this is picked up by my Readwise-to-Anki script. I'm still trying to figure out a good method
for this. OCR feels a little better than retyping but it's still clunky.

### Custom Scripts

Basically, I have two (terrible, terrible quality) things going on:

1. [Rip highlights from PDFs](https://github.com/burke/kindle2anki/blob/master/pdf-extract/lol.rb);
2. [Download all highlights from Readwise, merge them with the PDF highlights, and import them into
   Anki](https://github.com/burke/kindle2anki/blob/master/kindle2anki.rb).

There's not much to say about the former script. I extract the document title and author from the
PDF, and the text of each annotation (as well as any attached note), and dump them in JSON format.

The latter script uses the very-useful [https://readwise.io/munger](https://readwise.io/munger),
which exports all of your highlights in one JSON file. It then dumps these fields in a
tab-separated-value file, alongside a digest of a few fields, which I can use as a unique key to
prevent duplication in case I change the note later on in Anki. I then import this file into Anki.
Any cards with matching digest fields are ignored. If I ever want to "delete" a note, I suspend it
instead of deleting it, to prevent my script from re-creating it.

### Anki Configuration

I've created a Note type called "Highlight", with the following fields:

* Hash
* Highlight
* Note
* Author
* Source
* Medium

I also have a "Highlights" deck. I enjoy reviewing these separately from the rest of my cards.

I made a few minor changes to the Study options for this deck:

* Steps: "10 2880" (These can graduate to a lower frequency much faster than normal cards)
* Easy Interval: 7 (I want to be able to push a new card off for a week the first time I see it)
* Order: Show new cards in random order

The "Highlight" Note type has one Card type:

#### Front Template

```
<div class="book source">{{Source}}</div>
<div class="book author">{{Author}}</div>

<div class="book">{{Highlight}}</div>


<div class="book note">{{Note}}</div>
```

#### Styling

```
@import url("_style.anki.main.css");
```

*(see [_style.anki.main.css](https://burkelibbey.s3.amazonaws.com/_style.anki.main.css))*

#### Back Template

```
{{FrontSide}}
```

### Actual Review

Now that these scripts are "done", it only takes a few seconds to vacuum up all my new highlights
into Anki (except for physical books). The actual review process is simply reviewing all the due
cards each day. I typically have between 1 and 20 to glance through.

## Integrate

As I go through cards each day, I filter them into one of three buckets:

* **Yes**: I want to convert this note into one or more permanent knowledge items (i.e. Basic or
  Cloze cards). Mark it and suspend it.
* **No**: I don't think I'll ever get value out of this again. Suspend the card.
* **Maybe**: I'm not ready yet to commit to marking or suspending this. Maybe I want to defer the
  choice, or maybe I just want to see it again every now and then without actually memorizing it.

Every week or so, when I'm at a real keyboard, I'll look at my marked cards, convert them into
normal cards (Basic or Cloze), and un-mark them. These become integrated knowledge.

Highlights will tend to stay relatively fresh when reviewed in this way, and knowledge integrated
into Q&A-style cards becomes permanent. The underpinning of this system is a commitment to reviewing
all due cards in Anki each day, which luckily I do.

## Conclusion

There it is in a nutshell. You may notice that this is a kind of [incremental
reading](https://www.supermemo.com/help/read.htm) system, and I'm trying to figure out how much more
of that concept to try to bring in. I'll continue to update this post as I continue to evolve this
system.

---

## A Note About Zettelkasten

I spoke with Simon shortly after writing this post and we agreed that the
[Zettelkasten](https://zettelkasten.de/posts/zettelkasten-improves-thinking-writing/) system may be
an ideal way to manage this Capture/Review/Integrate workflow. I tried this out for a while, first
using [Dynalist](https://dynalist.io/) and later
[org-brain](https://github.com/Kungsgeten/org-brain). I wrote an `org-brain`-to-Anki importer, and
reviewed captured knowledge there on a fairly long interval.

I had a couple of problems with this method:

1. Putting everything in one large tree structure (or graph in the case of `org-brain`) felt
   unnatural: I spent too much time trying to find even tangentially-related notes.
2. The eventual access mode of accessing a group of related notes together is not really something
   I care to optimize for.
3. I ended up not capturing knowledge this way, because it felt too high-effort: While a physical
   zettelkasten makes sense for reading on paper, I couldn't find a good way to make it as
   low-effort as what I have right now with digital capture.

## How I Actually *Want* This to Work

I like most of the system I have now, but I'd love to have this all implemented as a series of
importers in [Perkeep](https://perkeep.org) rather than routing three quarters of it through
readwise, and a script to generate an Anki import file from the contents of my Perkeep instance.
