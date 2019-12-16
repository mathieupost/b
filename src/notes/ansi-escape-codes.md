---
title: "Everything you never wanted to know about ANSI escape codes"
date: 2019-02-13
toc: false
...

**See also: [Flash cards (Anki deck) for memorization](https://ankiweb.net/shared/info/1616925913)**

My team writes a lot of command line tools, and we like to assume that people aren't using a literal
[VT100](https://en.wikipedia.org/wiki/VT100) (meaning: we liberally use colours, italics, and
basically every other terminal feature available to us). This tends to result in strings in our code
that look a little like this:

```
"\x1b[A\r\x1b[K\x1b[1;32mopened \x1b[1;4;34m%s\x1b[0;1;32m in your browser.\x1b[0m\n"
```

If you're like most people, your face just melted, but it's actually really simple. This page is
a crash course in what all of these things mean, and how to learn to read and write them
effectively.

### `\x1b`

ANSI escapes always start with `\x1b`, or `\e`, or `\033`. These are all the same thing: they're
just various ways of inserting the byte 27 into a string. If you look at an [ASCII
table](http://www.asciitable.com/), `0x1b` is literally called `ESC`, and this is basically why.

### Control sequences

The majority of these escape codes start with `\x1b[`. This pair of bytes is referred to as `CSI`,
or "Control Sequence Introducer". By and large, a control sequence looks like:

```
0x1B + "[" + <zero or more numbers, separated by ";"> + <a letter>
```

It's helpful to think of it this way: the terminating letter is a function name, and the intervening
numbers as function arguments, delimited by semicolons rather than the typical commas.

If you see `\x1b[0;1;34m`, you can read it like this:

```
\x1b[  # call a function
0;1;34 # function arguments (0, 1, 34)
m      # function name
```

In effect, this is `m(0, 1, 34)`. Similarly, `\x1b[A` is just `A()`.

### Available functions

So with that mental model—reading escape sequences as function invocations—here's an abridged
documentation of the "standard library", as it were:

| | name | signature | description&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
|---|---|---|---|
| A | Cursor Up | (n=1) | Move cursor up by `n` |
| B | Cursor Down | (n=1) | Move cursor down by `n` |
| C | Cursor Forward | (n=1) | Move cursor forward by `n` |
| D | Cursor Back | (n=1) | Move cursor back by `n` |
| E | Cursor Next Line | (n=1) | Move cursor to the beginning of the line `n` lines down |
| F | Cursor Previous Line | (n=1) | Move cursor to the beginning of the line `n` lines up |
| G | Cursor Horizontal Absolute | (n=1) | Move cursor to the the column `n` within the current row |
| H | Cursor Position | (n=1, m=1) | Move cursor to row `n`, column `m`, counting from the top left corner |
| J | Erase in Display | (n=0) | Clear part of the screen. 0, 1, 2, and 3 have various specific functions |
| K | Erase in Line | (n=0) | Clear part of the line. 0, 1, and 2 have various specific functions |
| S | Scroll Up | (n=1) | Scroll window up by `n` lines |
| T | Scroll Down | (n=1) | Scroll window down by `n` lines |
| s | Save Cursor Position | () | Save current cursor position for use with `u` |
| u | Restore Cursor Position | () | Set cursor back to position last saved by `s` |
| f | ... | ... | (same as G) |
| m | SGR | (*) | Set graphics mode. More below |

For practice, you might try interpreting the following string:

```
\x1b[3A\x1b[4D\x1b[shello\x1b[J\x1b[1;3Hworld\x1b[u\x1b[13T
```

### SGR

The SGR ("Select Graphics Rendition") function (`m`) has a much more complex signature than the
other functions. An—again, abridged—guide to SGR arguments:

| value | name&nbsp;/&nbsp;description&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
|---|---|
| 0 | Reset: turn off all attributes |
| 1 | Bold (or bright, it's up to the terminal and the user config to some extent) |
| 3 | Italic |
| 4 | Underline |
| 30–37 | Set text colour from the basic colour palette of 0–7 |
| 38;5;*n* | Set text colour to index `n` in a [256-colour palette](https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg) (e.g. `\x1b[38;5;34m`) |
| 38;2;*r*;*g*;*b* | Set text colour to an RGB value (e.g. `\x1b[38;2;255;255;0m`) |
| 40–47 | Set background colour |
| 48;5;*n* | Set background colour to index `n` in a 256-colour palette |
| 48;2;*r*;*g*;*b* | Set background colour to an RGB value |
| 90–97 | Set text colour from the **bright** colour palette of 0–7 |
| 100–107 | Set background colour from the **bright** colour palette of 0–7 |

Multiple SGR arguments can always be concatenated using another `;`, and they will be applied in the
order they are encountered. It's especially common to see `0;` before some other argument, in order
to reset the state before applying our own.

### Colour Palettes

The basic colour palette has 8 entries:

* 0: black
* 1: red
* 2: green
* 3: yellow
* 4: blue
* 5: magenta
* 6: cyan
* 7: white

A useful way to help remember this, or at least to select colours for use, is that, with the
exception of 0/black, the colours are ordered by usefulness, with highest first: red text is very
useful for indicating failures, green is useful for indicating extreme success, yellow for warnings,
and then blue, magenta, and cyan for progressively more obscure conditions or decoration.

0 and 7 are less useful for text because one or the other will generally look nearly-unreadable
depending on whether the user has a light or a dark background.

Terminals will also have a "bright" version of this palette (activated using 90–97 / 100–107). These
are the same (black/red/green/etc.) but generally noticeably brighter than their regular
counterparts.

For practice, you might try to figure out how this string would display:

```
\x1b[38;2;255;255;0mH\x1b[0;1;3;35me\x1b[95ml\x1b[42ml\x1b[0;41mo\x1b[0m
```

### Miscellany

Another pair of useful escapes is `\x1b[?25h` and `\x1b[?25l`. These show and hide the cursor,
respectively. Try not to think too hard about the syntax here: `?25` means something to do with the
cursor and `h` and `l` stand for "high" and "low": imagine a bit indicating whether the cursor
should be visible. The "high" value (1) would indicate "show"; the "low" value (0) would indicate
"hide".

Show/hide is useful when you're going to draw some stuff that'll cause the cursor to jump around
like crazy, for example, repainting a couple of the last few lines to update them with new content.

One other thing that we use frequently is `\r`, or Carriage Return, which is functionally similar or
identical to `\x1b[1G`. It just moves the cursor to the start of the line.

### Summary

That was a lot of information, but that's essentially everything you need to know in order to
competently read and write ANSI escape codes in a terminal.

If you want to learn this more thoroughly, [I've put together a set of flash cards to
help](https://ankiweb.net/shared/info/1616925913).
