" -----------------------------------------------------------------------------
" File: bbox.vim
" Description: Retro groove color scheme for Vim
" Author: morhetz <morhetz@gmail.com>
" Source: https://github.com/morhetz/bbox
" Last Modified: 12 Aug 2017
" -----------------------------------------------------------------------------

" Supporting code -------------------------------------------------------------
" Initialisation: {{{

if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name='bbox'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" }}}
" Global Settings: {{{

if !exists('g:bbox_bold')
  let g:bbox_bold=1
endif
if !exists('g:bbox_italic')
  if has('gui_running') || $TERM_ITALICS == 'true'
    let g:bbox_italic=1
  else
    let g:bbox_italic=0
  endif
endif
if !exists('g:bbox_undercurl')
  let g:bbox_undercurl=1
endif
if !exists('g:bbox_underline')
  let g:bbox_underline=1
endif
if !exists('g:bbox_inverse')
  let g:bbox_inverse=1
endif

if !exists('g:bbox_guisp_fallback') || index(['fg', 'bg'], g:bbox_guisp_fallback) == -1
  let g:bbox_guisp_fallback='NONE'
endif

if !exists('g:bbox_improved_strings')
  let g:bbox_improved_strings=0
endif

if !exists('g:bbox_improved_warnings')
  let g:bbox_improved_warnings=0
endif

if !exists('g:bbox_termcolors')
  let g:bbox_termcolors=256
endif

if !exists('g:bbox_invert_indent_guides')
  let g:bbox_invert_indent_guides=0
endif

if exists('g:bbox_contrast')
  echo 'g:bbox_contrast is deprecated; use g:bbox_contrast_light and g:bbox_contrast_dark instead'
endif

if !exists('g:bbox_contrast_dark')
  let g:bbox_contrast_dark='medium'
endif

if !exists('g:bbox_contrast_light')
  let g:bbox_contrast_light='medium'
endif

let s:is_dark=(&background == 'dark')

" }}}
" Palette: {{{

" setup palette dictionary
let s:bb = {}

" fill it with absolute colors
let s:bb.dark0_hard  = ['#1d2021', 234]
let s:bb.dark0       = ['#282828', 235]
let s:bb.dark0_soft  = ['#32302f', 236]
let s:bb.dark1       = ['#3c3836', 237]
let s:bb.dark2       = ['#504945', 239]
let s:bb.dark3       = ['#665c54', 241]
let s:bb.dark4       = ['#7c6f64', 243]
let s:bb.dark4_256   = ['#7c6f64', 243]

let s:bb.gray_245    = ['#928374', 245]
let s:bb.gray_244    = ['#928374', 244]

let s:bb.light0_hard = ['#f9f5d7', 230]
let s:bb.light0      = ['#fbf1c7', 229]
let s:bb.light0_soft = ['#f2e5bc', 228]
let s:bb.light1      = ['#ebdbb2', 223]
let s:bb.light2      = ['#d5c4a1', 250]
let s:bb.light3      = ['#bdae93', 248]
let s:bb.light4      = ['#a89984', 246]
let s:bb.light4_256  = ['#a89984', 246]

let s:bb.bright_red     = ['#fb4934', 167]
let s:bb.bright_green   = ['#b8bb26', 142]
let s:bb.bright_yellow  = ['#fabd2f', 214]
let s:bb.bright_blue    = ['#83a598', 109]
let s:bb.bright_purple  = ['#d3869b', 175]
let s:bb.bright_aqua    = ['#8ec07c', 108]
let s:bb.bright_orange  = ['#fe8019', 208]

let s:bb.neutral_red    = ['#cc241d', 124]
let s:bb.neutral_green  = ['#98971a', 106]
let s:bb.neutral_yellow = ['#d79921', 172]
let s:bb.neutral_blue   = ['#458588', 66]
let s:bb.neutral_purple = ['#b16286', 132]
let s:bb.neutral_aqua   = ['#689d6a', 72]
let s:bb.neutral_orange = ['#d65d0e', 166]

let s:bb.faded_red      = ['#9d0006', 88]
let s:bb.faded_green    = ['#79740e', 100]
let s:bb.faded_yellow   = ['#b57614', 136]
let s:bb.faded_blue     = ['#076678', 24]
let s:bb.faded_purple   = ['#8f3f71', 96]
let s:bb.faded_aqua     = ['#427b58', 66]
let s:bb.faded_orange   = ['#af3a03', 130]

" }}}
" Setup Emphasis: {{{

let s:bold = 'bold,'
if g:bbox_bold == 0
  let s:bold = ''
endif

let s:italic = 'italic,'
if g:bbox_italic == 0
  let s:italic = ''
endif

let s:underline = 'underline,'
if g:bbox_underline == 0
  let s:underline = ''
endif

let s:undercurl = 'undercurl,'
if g:bbox_undercurl == 0
  let s:undercurl = ''
endif

let s:inverse = 'inverse,'
if g:bbox_inverse == 0
  let s:inverse = ''
endif

" }}}
" Setup Colors: {{{

let s:vim_bg = ['bg', 'bg']
let s:vim_fg = ['fg', 'fg']
let s:none = ['NONE', 'NONE']

" determine relative colors
if s:is_dark
  let s:bg0  = s:bb.dark0
  if g:bbox_contrast_dark == 'soft'
    let s:bg0  = s:bb.dark0_soft
  elseif g:bbox_contrast_dark == 'hard'
    let s:bg0  = s:bb.dark0_hard
  endif

  let s:bg1  = s:bb.dark1
  let s:bg2  = s:bb.dark2
  let s:bg3  = s:bb.dark3
  let s:bg4  = s:bb.dark4

  let s:gray = s:bb.gray_245

  let s:fg0 = s:bb.light0
  let s:fg1 = s:bb.light1
  let s:fg2 = s:bb.light2
  let s:fg3 = s:bb.light3
  let s:fg4 = s:bb.light4

  let s:fg4_256 = s:bb.light4_256

  let s:red    = s:bb.bright_red
  let s:green  = s:bb.bright_green
  let s:yellow = s:bb.bright_yellow
  let s:blue   = s:bb.bright_blue
  let s:purple = s:bb.bright_purple
  let s:aqua   = s:bb.bright_aqua
  let s:orange = s:bb.bright_orange
else
  let s:bg0  = s:bb.light0
  if g:bbox_contrast_light == 'soft'
    let s:bg0  = s:bb.light0_soft
  elseif g:bbox_contrast_light == 'hard'
    let s:bg0  = s:bb.light0_hard
  endif

  let s:bg1  = s:bb.light1
  let s:bg2  = s:bb.light2
  let s:bg3  = s:bb.light3
  let s:bg4  = s:bb.light4

  let s:gray = s:bb.gray_244

  let s:fg0 = s:bb.dark0
  let s:fg1 = s:bb.dark1
  let s:fg2 = s:bb.dark2
  let s:fg3 = s:bb.dark3
  let s:fg4 = s:bb.dark4

  let s:fg4_256 = s:bb.dark4_256

  let s:red    = s:bb.faded_red
  let s:green  = s:bb.faded_green
  let s:yellow = s:bb.faded_yellow
  let s:blue   = s:bb.faded_blue
  let s:purple = s:bb.faded_purple
  let s:aqua   = s:bb.faded_aqua
  let s:orange = s:bb.faded_orange
endif

" reset to 16 colors fallback
if g:bbox_termcolors == 16
  let s:bg0[1]    = 0
  let s:fg4[1]    = 7
  let s:gray[1]   = 8
  let s:red[1]    = 9
  let s:green[1]  = 10
  let s:yellow[1] = 11
  let s:blue[1]   = 12
  let s:purple[1] = 13
  let s:aqua[1]   = 14
  let s:fg1[1]    = 15
endif

" save current relative colors back to palette dictionary
let s:bb.bg0 = s:bg0
let s:bb.bg1 = s:bg1
let s:bb.bg2 = s:bg2
let s:bb.bg3 = s:bg3
let s:bb.bg4 = s:bg4

let s:bb.gray = s:gray

let s:bb.fg0 = s:fg0
let s:bb.fg1 = s:fg1
let s:bb.fg2 = s:fg2
let s:bb.fg3 = s:fg3
let s:bb.fg4 = s:fg4

let s:bb.fg4_256 = s:fg4_256

let s:bb.red    = s:red
let s:bb.green  = s:green
let s:bb.yellow = s:yellow
let s:bb.blue   = s:blue
let s:bb.purple = s:purple
let s:bb.aqua   = s:aqua
let s:bb.orange = s:orange

" }}}
" Setup Terminal Colors For Neovim: {{{

if has('nvim')
  let g:terminal_color_0 = s:bg0[0]
  let g:terminal_color_8 = s:gray[0]

  let g:terminal_color_1 = s:bb.neutral_red[0]
  let g:terminal_color_9 = s:red[0]

  let g:terminal_color_2 = s:bb.neutral_green[0]
  let g:terminal_color_10 = s:green[0]

  let g:terminal_color_3 = s:bb.neutral_yellow[0]
  let g:terminal_color_11 = s:yellow[0]

  let g:terminal_color_4 = s:bb.neutral_blue[0]
  let g:terminal_color_12 = s:blue[0]

  let g:terminal_color_5 = s:bb.neutral_purple[0]
  let g:terminal_color_13 = s:purple[0]

  let g:terminal_color_6 = s:bb.neutral_aqua[0]
  let g:terminal_color_14 = s:aqua[0]

  let g:terminal_color_7 = s:fg4[0]
  let g:terminal_color_15 = s:fg1[0]
endif

" }}}
" Overload Setting: {{{

let s:hls_cursor = s:orange
if exists('g:bbox_hls_cursor')
  let s:hls_cursor = get(s:bb, g:bbox_hls_cursor)
endif

let s:number_column = s:none
if exists('g:bbox_number_column')
  let s:number_column = get(s:bb, g:bbox_number_column)
endif

let s:sign_column = s:bg1

if exists('g:gitgutter_override_sign_column_highlight') &&
      \ g:gitgutter_override_sign_column_highlight == 1
  let s:sign_column = s:number_column
else
  let g:gitgutter_override_sign_column_highlight = 0

  if exists('g:bbox_sign_column')
    let s:sign_column = get(s:bb, g:bbox_sign_column)
  endif
endif

let s:color_column = s:bg1
if exists('g:bbox_color_column')
  let s:color_column = get(s:bb, g:bbox_color_column)
endif

let s:vert_split = s:bg0
if exists('g:bbox_vert_split')
  let s:vert_split = get(s:bb, g:bbox_vert_split)
endif

let s:invert_signs = ''
if exists('g:bbox_invert_signs')
  if g:bbox_invert_signs == 1
    let s:invert_signs = s:inverse
  endif
endif

let s:invert_selection = s:inverse
if exists('g:bbox_invert_selection')
  if g:bbox_invert_selection == 0
    let s:invert_selection = ''
  endif
endif

let s:invert_tabline = ''
if exists('g:bbox_invert_tabline')
  if g:bbox_invert_tabline == 1
    let s:invert_tabline = s:inverse
  endif
endif

let s:italicize_comments = s:italic
if exists('g:bbox_italicize_comments')
  if g:bbox_italicize_comments == 0
    let s:italicize_comments = ''
  endif
endif

let s:italicize_strings = ''
if exists('g:bbox_italicize_strings')
  if g:bbox_italicize_strings == 1
    let s:italicize_strings = s:italic
  endif
endif

" }}}
" Highlighting Function: {{{

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  " foreground
  let fg = a:fg

  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:none
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'NONE,'
  endif

  " special fallback
  if a:0 >= 3
    if g:bbox_guisp_fallback != 'NONE'
      let fg = a:3
    endif

    " bg fallback mode should invert higlighting
    if g:bbox_guisp_fallback == 'bg'
      let emstr .= 'inverse,'
    endif
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
        \ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
        \ 'gui=' . emstr[:-2], 'cterm=' . emstr[:-2]
        \ ]

  " special
  if a:0 >= 3
    call add(histring, 'guisp=' . a:3[0])
  endif

  execute join(histring, ' ')
endfunction

" }}}
" Bbox Hi Groups: {{{

" memoize common hi groups
call s:HL('BboxFg0', s:fg0)
call s:HL('BboxFg1', s:fg1)
call s:HL('BboxFg2', s:fg2)
call s:HL('BboxFg3', s:fg3)
call s:HL('BboxFg4', s:fg4)
call s:HL('BboxGray', s:gray)
call s:HL('BboxBg0', s:bg0)
call s:HL('BboxBg1', s:bg1)
call s:HL('BboxBg2', s:bg2)
call s:HL('BboxBg3', s:bg3)
call s:HL('BboxBg4', s:bg4)

call s:HL('BboxRed', s:red)
call s:HL('BboxRedBold', s:red, s:none, s:bold)
call s:HL('BboxGreen', s:green)
call s:HL('BboxGreenBold', s:green, s:none, s:bold)
call s:HL('BboxYellow', s:yellow)
call s:HL('BboxYellowBold', s:yellow, s:none, s:bold)
call s:HL('BboxBlue', s:blue)
call s:HL('BboxBlueBold', s:blue, s:none, s:bold)
call s:HL('BboxPurple', s:purple)
call s:HL('BboxPurpleBold', s:purple, s:none, s:bold)
call s:HL('BboxAqua', s:aqua)
call s:HL('BboxAquaBold', s:aqua, s:none, s:bold)
call s:HL('BboxOrange', s:orange)
call s:HL('BboxOrangeBold', s:orange, s:none, s:bold)

call s:HL('BboxRedSign', s:red, s:sign_column, s:invert_signs)
call s:HL('BboxGreenSign', s:green, s:sign_column, s:invert_signs)
call s:HL('BboxYellowSign', s:yellow, s:sign_column, s:invert_signs)
call s:HL('BboxBlueSign', s:blue, s:sign_column, s:invert_signs)
call s:HL('BboxPurpleSign', s:purple, s:sign_column, s:invert_signs)
call s:HL('BboxAquaSign', s:aqua, s:sign_column, s:invert_signs)
call s:HL('BboxOrangeSign', s:orange, s:sign_column, s:invert_signs)

" }}}

" Vanilla colorscheme ---------------------------------------------------------
" General UI: {{{

" Normal text
call s:HL('Normal', s:fg1, s:bg0)

" Correct background (see issue #7):
" --- Problem with changing between dark and light on 256 color terminal
" --- https://github.com/morhetz/bbox/issues/7
if s:is_dark
  set background=dark
else
  set background=light
endif

if version >= 700
  " Screen line that the cursor is
  call s:HL('CursorLine',   s:none, s:bg1)
  " Screen column that the cursor is
  hi! link CursorColumn CursorLine

  " Tab pages line filler
  call s:HL('TabLineFill', s:bg4, s:bg1, s:invert_tabline)
  " Active tab page label
  call s:HL('TabLineSel', s:green, s:bg1, s:invert_tabline)
  " Not active tab page label
  hi! link TabLine TabLineFill

  " Match paired bracket under the cursor
  call s:HL('MatchParen', s:none, s:bg3, s:bold)
endif

if version >= 703
  " Highlighted screen columns
  call s:HL('ColorColumn',  s:none, s:color_column)

  " Concealed element: \lambda → λ
  call s:HL('Conceal', s:blue, s:none)

  " Line number of CursorLine
  call s:HL('CursorLineNr', s:yellow, s:bg1)
endif

hi! link NonText BboxBg2
hi! link SpecialKey BboxBg2

call s:HL('Visual',    s:none,  s:bg3, s:invert_selection)
hi! link VisualNOS Visual

call s:HL('Search',    s:yellow, s:bg0, s:inverse)
call s:HL('IncSearch', s:hls_cursor, s:bg0, s:inverse)

call s:HL('Underlined', s:blue, s:none, s:underline)

call s:HL('StatusLine',   s:bg2, s:fg1, s:inverse)
call s:HL('StatusLineNC', s:bg1, s:fg4, s:inverse)

" The column separating vertically split windows
call s:HL('VertSplit', s:bg3, s:vert_split)

" Current match in wildmenu completion
call s:HL('WildMenu', s:blue, s:bg2, s:bold)

" Directory names, special names in listing
hi! link Directory BboxGreenBold

" Titles for output from :set all, :autocmd, etc.
hi! link Title BboxGreenBold

" Error messages on the command line
call s:HL('ErrorMsg',   s:bg0, s:red, s:bold)
" More prompt: -- More --
hi! link MoreMsg BboxYellowBold
" Current mode message: -- INSERT --
hi! link ModeMsg BboxYellowBold
" 'Press enter' prompt and yes/no questions
hi! link Question BboxOrangeBold
" Warning messages
hi! link WarningMsg BboxRedBold

" }}}
" Gutter: {{{

" Line number for :number and :# commands
call s:HL('LineNr', s:bg4, s:number_column)

" Column where signs are displayed
call s:HL('SignColumn', s:none, s:sign_column)

" Line used for closed folds
call s:HL('Folded', s:gray, s:bg1, s:italic)
" Column where folds are displayed
call s:HL('FoldColumn', s:gray, s:bg1)

" }}}
" Cursor: {{{

" Character under cursor
call s:HL('Cursor', s:none, s:none, s:inverse)
" Visual mode cursor, selection
hi! link vCursor Cursor
" Input moder cursor
hi! link iCursor Cursor
" Language mapping cursor
hi! link lCursor Cursor

" }}}
" Syntax Highlighting: {{{

if g:bbox_improved_strings == 0
  hi! link Special BboxOrange
else
  call s:HL('Special', s:orange, s:bg1, s:italicize_strings)
endif

call s:HL('Comment', s:gray, s:none, s:italicize_comments)
call s:HL('Todo', s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('Error', s:red, s:vim_bg, s:bold . s:inverse)

" Generic statement
hi! link Statement BboxRed
" if, then, else, endif, swicth, etc.
hi! link Conditional BboxRed
" for, do, while, etc.
hi! link Repeat BboxRed
" case, default, etc.
hi! link Label BboxRed
" try, catch, throw
hi! link Exception BboxRed
" sizeof, "+", "*", etc.
hi! link Operator Normal
" Any other keyword
hi! link Keyword BboxRed

" Variable name
hi! link Identifier BboxBlue
" Function name
hi! link Function BboxGreenBold

" Generic preprocessor
hi! link PreProc BboxAqua
" Preprocessor #include
hi! link Include BboxAqua
" Preprocessor #define
hi! link Define BboxAqua
" Same as Define
hi! link Macro BboxAqua
" Preprocessor #if, #else, #endif, etc.
hi! link PreCondit BboxAqua

" Generic constant
hi! link Constant BboxPurple
" Character constant: 'c', '/n'
hi! link Character BboxPurple
" String constant: "this is a string"
if g:bbox_improved_strings == 0
  call s:HL('String',  s:green, s:none, s:italicize_strings)
else
  call s:HL('String',  s:fg1, s:bg1, s:italicize_strings)
endif
" Boolean constant: TRUE, false
hi! link Boolean BboxPurple
" Number constant: 234, 0xff
hi! link Number BboxPurple
" Floating point constant: 2.3e10
hi! link Float BboxPurple

" Generic type
hi! link Type BboxYellow
" static, register, volatile, etc
hi! link StorageClass BboxOrange
" struct, union, enum, etc.
hi! link Structure BboxAqua
" typedef
hi! link Typedef BboxYellow

" }}}
" Completion Menu: {{{

if version >= 700
  " Popup menu: normal item
  call s:HL('Pmenu', s:fg1, s:bg2)
  " Popup menu: selected item
  call s:HL('PmenuSel', s:bg2, s:blue, s:bold)
  " Popup menu: scrollbar
  call s:HL('PmenuSbar', s:none, s:bg2)
  " Popup menu: scrollbar thumb
  call s:HL('PmenuThumb', s:none, s:bg4)
endif

" }}}
" Diffs: {{{

call s:HL('DiffDelete', s:red, s:bg0, s:inverse)
call s:HL('DiffAdd',    s:green, s:bg0, s:inverse)
"call s:HL('DiffChange', s:bg0, s:blue)
"call s:HL('DiffText',   s:bg0, s:yellow)

" Alternative setting
call s:HL('DiffChange', s:aqua, s:bg0, s:inverse)
call s:HL('DiffText',   s:yellow, s:bg0, s:inverse)

" }}}
" Spelling: {{{

if has("spell")
  " Not capitalised word, or compile warnings
  if g:bbox_improved_warnings == 0
    call s:HL('SpellCap',   s:none, s:none, s:undercurl, s:red)
  else
    call s:HL('SpellCap',   s:green, s:none, s:bold . s:italic)
  endif
  " Not recognized word
  call s:HL('SpellBad',   s:none, s:none, s:undercurl, s:blue)
  " Wrong spelling for selected region
  call s:HL('SpellLocal', s:none, s:none, s:undercurl, s:aqua)
  " Rare word
  call s:HL('SpellRare',  s:none, s:none, s:undercurl, s:purple)
endif

" }}}

" Plugin specific -------------------------------------------------------------
" EasyMotion: {{{

hi! link EasyMotionTarget Search
hi! link EasyMotionShade Comment

" }}}
" Sneak: {{{

hi! link Sneak Search
hi! link SneakLabel Search

" }}}
" Indent Guides: {{{

if !exists('g:indent_guides_auto_colors')
  let g:indent_guides_auto_colors = 0
endif

if g:indent_guides_auto_colors == 0
  if g:bbox_invert_indent_guides == 0
    call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2)
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg1)
  else
    call s:HL('IndentGuidesOdd', s:vim_bg, s:bg2, s:inverse)
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg3, s:inverse)
  endif
endif

" }}}
" IndentLine: {{{

if !exists('g:indentLine_color_term')
  let g:indentLine_color_term = s:bg2[1]
endif
if !exists('g:indentLine_color_gui')
  let g:indentLine_color_gui = s:bg2[0]
endif

" }}}
" Rainbow Parentheses: {{{

if !exists('g:rbpt_colorpairs')
  let g:rbpt_colorpairs =
    \ [
      \ ['blue', '#458588'], ['magenta', '#b16286'],
      \ ['red',  '#cc241d'], ['166',     '#d65d0e']
    \ ]
endif

let g:rainbow_guifgs = [ '#d65d0e', '#cc241d', '#b16286', '#458588' ]
let g:rainbow_ctermfgs = [ '166', 'red', 'magenta', 'blue' ]

if !exists('g:rainbow_conf')
   let g:rainbow_conf = {}
endif
if !has_key(g:rainbow_conf, 'guifgs')
   let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
endif
if !has_key(g:rainbow_conf, 'ctermfgs')
   let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
endif

let g:niji_dark_colours = g:rbpt_colorpairs
let g:niji_light_colours = g:rbpt_colorpairs

"}}}
" GitGutter: {{{

hi! link GitGutterAdd BboxGreenSign
hi! link GitGutterChange BboxAquaSign
hi! link GitGutterDelete BboxRedSign
hi! link GitGutterChangeDelete BboxAquaSign

" }}}
" GitCommit: "{{{

hi! link gitcommitSelectedFile BboxGreen
hi! link gitcommitDiscardedFile BboxRed

" }}}
" Signify: {{{

hi! link SignifySignAdd BboxGreenSign
hi! link SignifySignChange BboxAquaSign
hi! link SignifySignDelete BboxRedSign

" }}}
" Syntastic: {{{

call s:HL('SyntasticError', s:none, s:none, s:undercurl, s:red)
call s:HL('SyntasticWarning', s:none, s:none, s:undercurl, s:yellow)

hi! link SyntasticErrorSign BboxRedSign
hi! link SyntasticWarningSign BboxYellowSign

" }}}
" Signature: {{{
hi! link SignatureMarkText   BboxBlueSign
hi! link SignatureMarkerText BboxPurpleSign

" }}}
" ShowMarks: {{{

hi! link ShowMarksHLl BboxBlueSign
hi! link ShowMarksHLu BboxBlueSign
hi! link ShowMarksHLo BboxBlueSign
hi! link ShowMarksHLm BboxBlueSign

" }}}
" CtrlP: {{{

hi! link CtrlPMatch BboxYellow
hi! link CtrlPNoEntries BboxRed
hi! link CtrlPPrtBase BboxBg2
hi! link CtrlPPrtCursor BboxBlue
hi! link CtrlPLinePre BboxBg2

call s:HL('CtrlPMode1', s:blue, s:bg2, s:bold)
call s:HL('CtrlPMode2', s:bg0, s:blue, s:bold)
call s:HL('CtrlPStats', s:fg4, s:bg2, s:bold)

" }}}
" Startify: {{{

hi! link StartifyBracket BboxFg3
hi! link StartifyFile BboxFg1
hi! link StartifyNumber BboxBlue
hi! link StartifyPath BboxGray
hi! link StartifySlash BboxGray
hi! link StartifySection BboxYellow
hi! link StartifySpecial BboxBg2
hi! link StartifyHeader BboxOrange
hi! link StartifyFooter BboxBg2

" }}}
" Vimshell: {{{

let g:vimshell_escape_colors = [
  \ s:bg4[0], s:red[0], s:green[0], s:yellow[0],
  \ s:blue[0], s:purple[0], s:aqua[0], s:fg4[0],
  \ s:bg0[0], s:red[0], s:green[0], s:orange[0],
  \ s:blue[0], s:purple[0], s:aqua[0], s:fg0[0]
  \ ]

" }}}
" BufTabLine: {{{

call s:HL('BufTabLineCurrent', s:bg0, s:fg4)
call s:HL('BufTabLineActive', s:fg4, s:bg2)
call s:HL('BufTabLineHidden', s:bg4, s:bg1)
call s:HL('BufTabLineFill', s:bg0, s:bg0)

" }}}
" Asynchronous Lint Engine: {{{

call s:HL('ALEError', s:none, s:none, s:undercurl, s:red)
call s:HL('ALEWarning', s:none, s:none, s:undercurl, s:yellow)
call s:HL('ALEInfo', s:none, s:none, s:undercurl, s:blue)

hi! link ALEErrorSign BboxRedSign
hi! link ALEWarningSign BboxYellowSign
hi! link ALEInfoSign BboxBlueSign

" }}}
" Dirvish: {{{

hi! link DirvishPathTail BboxAqua
hi! link DirvishArg BboxYellow

" }}}
" Netrw: {{{

hi! link netrwDir BboxAqua
hi! link netrwClassify BboxAqua
hi! link netrwLink BboxGray
hi! link netrwSymLink BboxFg1
hi! link netrwExe BboxYellow
hi! link netrwComment BboxGray
hi! link netrwList BboxBlue
hi! link netrwHelpCmd BboxAqua
hi! link netrwCmdSep BboxFg3
hi! link netrwVersion BboxGreen

" }}}
" NERDTree: {{{

hi! link NERDTreeDir BboxAqua
hi! link NERDTreeDirSlash BboxAqua

hi! link NERDTreeOpenable BboxOrange
hi! link NERDTreeClosable BboxOrange

hi! link NERDTreeFile BboxFg1
hi! link NERDTreeExecFile BboxYellow

hi! link NERDTreeUp BboxGray
hi! link NERDTreeCWD BboxGreen
hi! link NERDTreeHelp BboxFg1

hi! link NERDTreeToggleOn BboxGreen
hi! link NERDTreeToggleOff BboxRed

" }}}
" Vim Multiple Cursors: {{{

call s:HL('multiple_cursors_cursor', s:none, s:none, s:inverse)
call s:HL('multiple_cursors_visual', s:none, s:bg2)

" }}}
" coc.nvim: {{{

hi! link CocErrorSign BboxRedSign
hi! link CocWarningSign BboxOrangeSign
hi! link CocInfoSign BboxYellowSign
hi! link CocHintSign BboxBlueSign
hi! link CocErrorFloat BboxRed
hi! link CocWarningFloat BboxOrange
hi! link CocInfoFloat BboxYellow
hi! link CocHintFloat BboxBlue
hi! link CocDiagnosticsError BboxRed
hi! link CocDiagnosticsWarning BboxOrange
hi! link CocDiagnosticsInfo BboxYellow
hi! link CocDiagnosticsHint BboxBlue

hi! link CocSelectedText BboxRed
hi! link CocCodeLens BboxGray

call s:HL('CocErrorHighlight', s:none, s:none, s:undercurl, s:red)
call s:HL('CocWarningHighlight', s:none, s:none, s:undercurl, s:orange)
call s:HL('CocInfoHighlight', s:none, s:none, s:undercurl, s:yellow)
call s:HL('CocHintHighlight', s:none, s:none, s:undercurl, s:blue)

" }}}

" Filetype specific -----------------------------------------------------------
" Diff: {{{

hi! link diffAdded BboxGreen
hi! link diffRemoved BboxRed
hi! link diffChanged BboxAqua

hi! link diffFile BboxOrange
hi! link diffNewFile BboxYellow

hi! link diffLine BboxBlue

" }}}
" Html: {{{

hi! link htmlTag BboxBlue
hi! link htmlEndTag BboxBlue

hi! link htmlTagName BboxAquaBold
hi! link htmlArg BboxAqua

hi! link htmlScriptTag BboxPurple
hi! link htmlTagN BboxFg1
hi! link htmlSpecialTagName BboxAquaBold

call s:HL('htmlLink', s:fg4, s:none, s:underline)

hi! link htmlSpecialChar BboxOrange

call s:HL('htmlBold', s:vim_fg, s:vim_bg, s:bold)
call s:HL('htmlBoldUnderline', s:vim_fg, s:vim_bg, s:bold . s:underline)
call s:HL('htmlBoldItalic', s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('htmlBoldUnderlineItalic', s:vim_fg, s:vim_bg, s:bold . s:underline . s:italic)

call s:HL('htmlUnderline', s:vim_fg, s:vim_bg, s:underline)
call s:HL('htmlUnderlineItalic', s:vim_fg, s:vim_bg, s:underline . s:italic)
call s:HL('htmlItalic', s:vim_fg, s:vim_bg, s:italic)

" }}}
" Xml: {{{

hi! link xmlTag BboxBlue
hi! link xmlEndTag BboxBlue
hi! link xmlTagName BboxBlue
hi! link xmlEqual BboxBlue
hi! link docbkKeyword BboxAquaBold

hi! link xmlDocTypeDecl BboxGray
hi! link xmlDocTypeKeyword BboxPurple
hi! link xmlCdataStart BboxGray
hi! link xmlCdataCdata BboxPurple
hi! link dtdFunction BboxGray
hi! link dtdTagName BboxPurple

hi! link xmlAttrib BboxAqua
hi! link xmlProcessingDelim BboxGray
hi! link dtdParamEntityPunct BboxGray
hi! link dtdParamEntityDPunct BboxGray
hi! link xmlAttribPunct BboxGray

hi! link xmlEntity BboxOrange
hi! link xmlEntityPunct BboxOrange
" }}}
" Vim: {{{

call s:HL('vimCommentTitle', s:fg4_256, s:none, s:bold . s:italicize_comments)

hi! link vimNotation BboxOrange
hi! link vimBracket BboxOrange
hi! link vimMapModKey BboxOrange
hi! link vimFuncSID BboxFg3
hi! link vimSetSep BboxFg3
hi! link vimSep BboxFg3
hi! link vimContinue BboxFg3

" }}}
" Clojure: {{{

hi! link clojureKeyword BboxBlue
hi! link clojureCond BboxOrange
hi! link clojureSpecial BboxOrange
hi! link clojureDefine BboxOrange

hi! link clojureFunc BboxYellow
hi! link clojureRepeat BboxYellow
hi! link clojureCharacter BboxAqua
hi! link clojureStringEscape BboxAqua
hi! link clojureException BboxRed

hi! link clojureRegexp BboxAqua
hi! link clojureRegexpEscape BboxAqua
call s:HL('clojureRegexpCharClass', s:fg3, s:none, s:bold)
hi! link clojureRegexpMod clojureRegexpCharClass
hi! link clojureRegexpQuantifier clojureRegexpCharClass

hi! link clojureParen BboxFg3
hi! link clojureAnonArg BboxYellow
hi! link clojureVariable BboxBlue
hi! link clojureMacro BboxOrange

hi! link clojureMeta BboxYellow
hi! link clojureDeref BboxYellow
hi! link clojureQuote BboxYellow
hi! link clojureUnquote BboxYellow

" }}}
" C: {{{

hi! link cOperator BboxPurple
hi! link cStructure BboxOrange

" }}}
" Python: {{{

hi! link pythonBuiltin BboxOrange
hi! link pythonBuiltinObj BboxOrange
hi! link pythonBuiltinFunc BboxOrange
hi! link pythonFunction BboxAqua
hi! link pythonDecorator BboxRed
hi! link pythonInclude BboxBlue
hi! link pythonImport BboxBlue
hi! link pythonRun BboxBlue
hi! link pythonCoding BboxBlue
hi! link pythonOperator BboxRed
hi! link pythonException BboxRed
hi! link pythonExceptions BboxPurple
hi! link pythonBoolean BboxPurple
hi! link pythonDot BboxFg3
hi! link pythonConditional BboxRed
hi! link pythonRepeat BboxRed
hi! link pythonDottedName BboxGreenBold

" }}}
" CSS: {{{

hi! link cssBraces BboxBlue
hi! link cssFunctionName BboxYellow
hi! link cssIdentifier BboxOrange
hi! link cssClassName BboxGreen
hi! link cssColor BboxBlue
hi! link cssSelectorOp BboxBlue
hi! link cssSelectorOp2 BboxBlue
hi! link cssImportant BboxGreen
hi! link cssVendor BboxFg1

hi! link cssTextProp BboxAqua
hi! link cssAnimationProp BboxAqua
hi! link cssUIProp BboxYellow
hi! link cssTransformProp BboxAqua
hi! link cssTransitionProp BboxAqua
hi! link cssPrintProp BboxAqua
hi! link cssPositioningProp BboxYellow
hi! link cssBoxProp BboxAqua
hi! link cssFontDescriptorProp BboxAqua
hi! link cssFlexibleBoxProp BboxAqua
hi! link cssBorderOutlineProp BboxAqua
hi! link cssBackgroundProp BboxAqua
hi! link cssMarginProp BboxAqua
hi! link cssListProp BboxAqua
hi! link cssTableProp BboxAqua
hi! link cssFontProp BboxAqua
hi! link cssPaddingProp BboxAqua
hi! link cssDimensionProp BboxAqua
hi! link cssRenderProp BboxAqua
hi! link cssColorProp BboxAqua
hi! link cssGeneratedContentProp BboxAqua

" }}}
" JavaScript: {{{

hi! link javaScriptBraces BboxFg1
hi! link javaScriptFunction BboxAqua
hi! link javaScriptIdentifier BboxRed
hi! link javaScriptMember BboxBlue
hi! link javaScriptNumber BboxPurple
hi! link javaScriptNull BboxPurple
hi! link javaScriptParens BboxFg3

" }}}
" YAJS: {{{

hi! link javascriptImport BboxAqua
hi! link javascriptExport BboxAqua
hi! link javascriptClassKeyword BboxAqua
hi! link javascriptClassExtends BboxAqua
hi! link javascriptDefault BboxAqua

hi! link javascriptClassName BboxYellow
hi! link javascriptClassSuperName BboxYellow
hi! link javascriptGlobal BboxYellow

hi! link javascriptEndColons BboxFg1
hi! link javascriptFuncArg BboxFg1
hi! link javascriptGlobalMethod BboxFg1
hi! link javascriptNodeGlobal BboxFg1
hi! link javascriptBOMWindowProp BboxFg1
hi! link javascriptArrayMethod BboxFg1
hi! link javascriptArrayStaticMethod BboxFg1
hi! link javascriptCacheMethod BboxFg1
hi! link javascriptDateMethod BboxFg1
hi! link javascriptMathStaticMethod BboxFg1

" hi! link javascriptProp BboxFg1
hi! link javascriptURLUtilsProp BboxFg1
hi! link javascriptBOMNavigatorProp BboxFg1
hi! link javascriptDOMDocMethod BboxFg1
hi! link javascriptDOMDocProp BboxFg1
hi! link javascriptBOMLocationMethod BboxFg1
hi! link javascriptBOMWindowMethod BboxFg1
hi! link javascriptStringMethod BboxFg1

hi! link javascriptVariable BboxOrange
" hi! link javascriptVariable BboxRed
" hi! link javascriptIdentifier BboxOrange
" hi! link javascriptClassSuper BboxOrange
hi! link javascriptIdentifier BboxOrange
hi! link javascriptClassSuper BboxOrange

" hi! link javascriptFuncKeyword BboxOrange
" hi! link javascriptAsyncFunc BboxOrange
hi! link javascriptFuncKeyword BboxAqua
hi! link javascriptAsyncFunc BboxAqua
hi! link javascriptClassStatic BboxOrange

hi! link javascriptOperator BboxRed
hi! link javascriptForOperator BboxRed
hi! link javascriptYield BboxRed
hi! link javascriptExceptions BboxRed
hi! link javascriptMessage BboxRed

hi! link javascriptTemplateSB BboxAqua
hi! link javascriptTemplateSubstitution BboxFg1

" hi! link javascriptLabel BboxBlue
" hi! link javascriptObjectLabel BboxBlue
" hi! link javascriptPropertyName BboxBlue
hi! link javascriptLabel BboxFg1
hi! link javascriptObjectLabel BboxFg1
hi! link javascriptPropertyName BboxFg1

hi! link javascriptLogicSymbols BboxFg1
hi! link javascriptArrowFunc BboxYellow

hi! link javascriptDocParamName BboxFg4
hi! link javascriptDocTags BboxFg4
hi! link javascriptDocNotation BboxFg4
hi! link javascriptDocParamType BboxFg4
hi! link javascriptDocNamedParamType BboxFg4

hi! link javascriptBrackets BboxFg1
hi! link javascriptDOMElemAttrs BboxFg1
hi! link javascriptDOMEventMethod BboxFg1
hi! link javascriptDOMNodeMethod BboxFg1
hi! link javascriptDOMStorageMethod BboxFg1
hi! link javascriptHeadersMethod BboxFg1

hi! link javascriptAsyncFuncKeyword BboxRed
hi! link javascriptAwaitFuncKeyword BboxRed

" }}}
" PanglossJS: {{{

hi! link jsClassKeyword BboxAqua
hi! link jsExtendsKeyword BboxAqua
hi! link jsExportDefault BboxAqua
hi! link jsTemplateBraces BboxAqua
hi! link jsGlobalNodeObjects BboxFg1
hi! link jsGlobalObjects BboxFg1
hi! link jsFunction BboxAqua
hi! link jsFuncParens BboxFg3
hi! link jsParens BboxFg3
hi! link jsNull BboxPurple
hi! link jsUndefined BboxPurple
hi! link jsClassDefinition BboxYellow

" }}}
" TypeScript: {{{

hi! link typeScriptReserved BboxAqua
hi! link typeScriptLabel BboxAqua
hi! link typeScriptFuncKeyword BboxAqua
hi! link typeScriptIdentifier BboxOrange
hi! link typeScriptBraces BboxFg1
hi! link typeScriptEndColons BboxFg1
hi! link typeScriptDOMObjects BboxFg1
hi! link typeScriptAjaxMethods BboxFg1
hi! link typeScriptLogicSymbols BboxFg1
hi! link typeScriptDocSeeTag Comment
hi! link typeScriptDocParam Comment
hi! link typeScriptDocTags vimCommentTitle
hi! link typeScriptGlobalObjects BboxFg1
hi! link typeScriptParens BboxFg3
hi! link typeScriptOpSymbols BboxFg3
hi! link typeScriptHtmlElemProperties BboxFg1
hi! link typeScriptNull BboxPurple
hi! link typeScriptInterpolationDelimiter BboxAqua

" }}}
" PureScript: {{{

hi! link purescriptModuleKeyword BboxAqua
hi! link purescriptModuleName BboxFg1
hi! link purescriptWhere BboxAqua
hi! link purescriptDelimiter BboxFg4
hi! link purescriptType BboxFg1
hi! link purescriptImportKeyword BboxAqua
hi! link purescriptHidingKeyword BboxAqua
hi! link purescriptAsKeyword BboxAqua
hi! link purescriptStructure BboxAqua
hi! link purescriptOperator BboxBlue

hi! link purescriptTypeVar BboxFg1
hi! link purescriptConstructor BboxFg1
hi! link purescriptFunction BboxFg1
hi! link purescriptConditional BboxOrange
hi! link purescriptBacktick BboxOrange

" }}}
" CoffeeScript: {{{

hi! link coffeeExtendedOp BboxFg3
hi! link coffeeSpecialOp BboxFg3
hi! link coffeeCurly BboxOrange
hi! link coffeeParen BboxFg3
hi! link coffeeBracket BboxOrange

" }}}
" Ruby: {{{

hi! link rubyStringDelimiter BboxGreen
hi! link rubyInterpolationDelimiter BboxAqua

" }}}
" ObjectiveC: {{{

hi! link objcTypeModifier BboxRed
hi! link objcDirective BboxBlue

" }}}
" Go: {{{

hi! link goDirective BboxAqua
hi! link goConstants BboxPurple
hi! link goDeclaration BboxRed
hi! link goDeclType BboxBlue
hi! link goBuiltins BboxOrange

" }}}
" Lua: {{{

hi! link luaIn BboxRed
hi! link luaFunction BboxAqua
hi! link luaTable BboxOrange

" }}}
" MoonScript: {{{

hi! link moonSpecialOp BboxFg3
hi! link moonExtendedOp BboxFg3
hi! link moonFunction BboxFg3
hi! link moonObject BboxYellow

" }}}
" Java: {{{

hi! link javaAnnotation BboxBlue
hi! link javaDocTags BboxAqua
hi! link javaCommentTitle vimCommentTitle
hi! link javaParen BboxFg3
hi! link javaParen1 BboxFg3
hi! link javaParen2 BboxFg3
hi! link javaParen3 BboxFg3
hi! link javaParen4 BboxFg3
hi! link javaParen5 BboxFg3
hi! link javaOperator BboxOrange

hi! link javaVarArg BboxGreen

" }}}
" Elixir: {{{

hi! link elixirDocString Comment

hi! link elixirStringDelimiter BboxGreen
hi! link elixirInterpolationDelimiter BboxAqua

hi! link elixirModuleDeclaration BboxYellow

" }}}
" Scala: {{{

" NB: scala vim syntax file is kinda horrible
hi! link scalaNameDefinition BboxFg1
hi! link scalaCaseFollowing BboxFg1
hi! link scalaCapitalWord BboxFg1
hi! link scalaTypeExtension BboxFg1

hi! link scalaKeyword BboxRed
hi! link scalaKeywordModifier BboxRed

hi! link scalaSpecial BboxAqua
hi! link scalaOperator BboxFg1

hi! link scalaTypeDeclaration BboxYellow
hi! link scalaTypeTypePostDeclaration BboxYellow

hi! link scalaInstanceDeclaration BboxFg1
hi! link scalaInterpolation BboxAqua

" }}}
" Markdown: {{{

call s:HL('markdownItalic', s:fg3, s:none, s:italic)

hi! link markdownH1 BboxGreenBold
hi! link markdownH2 BboxGreenBold
hi! link markdownH3 BboxYellowBold
hi! link markdownH4 BboxYellowBold
hi! link markdownH5 BboxYellow
hi! link markdownH6 BboxYellow

hi! link markdownCode BboxAqua
hi! link markdownCodeBlock BboxAqua
hi! link markdownCodeDelimiter BboxAqua

hi! link markdownBlockquote BboxGray
hi! link markdownListMarker BboxGray
hi! link markdownOrderedListMarker BboxGray
hi! link markdownRule BboxGray
hi! link markdownHeadingRule BboxGray

hi! link markdownUrlDelimiter BboxFg3
hi! link markdownLinkDelimiter BboxFg3
hi! link markdownLinkTextDelimiter BboxFg3

hi! link markdownHeadingDelimiter BboxOrange
hi! link markdownUrl BboxPurple
hi! link markdownUrlTitleDelimiter BboxGreen

call s:HL('markdownLinkText', s:gray, s:none, s:underline)
hi! link markdownIdDeclaration markdownLinkText

" }}}
" Haskell: {{{

" hi! link haskellType BboxYellow
" hi! link haskellOperators BboxOrange
" hi! link haskellConditional BboxAqua
" hi! link haskellLet BboxOrange
"
hi! link haskellType BboxFg1
hi! link haskellIdentifier BboxFg1
hi! link haskellSeparator BboxFg1
hi! link haskellDelimiter BboxFg4
hi! link haskellOperators BboxBlue
"
hi! link haskellBacktick BboxOrange
hi! link haskellStatement BboxOrange
hi! link haskellConditional BboxOrange

hi! link haskellLet BboxAqua
hi! link haskellDefault BboxAqua
hi! link haskellWhere BboxAqua
hi! link haskellBottom BboxAqua
hi! link haskellBlockKeywords BboxAqua
hi! link haskellImportKeywords BboxAqua
hi! link haskellDeclKeyword BboxAqua
hi! link haskellDeriving BboxAqua
hi! link haskellAssocType BboxAqua

hi! link haskellNumber BboxPurple
hi! link haskellPragma BboxPurple

hi! link haskellString BboxGreen
hi! link haskellChar BboxGreen

" }}}
" Json: {{{

hi! link jsonKeyword BboxGreen
hi! link jsonQuote BboxGreen
hi! link jsonBraces BboxFg1
hi! link jsonString BboxFg1

" }}}


" Functions -------------------------------------------------------------------
" Search Highlighting Cursor {{{

function! BboxHlsShowCursor()
  call s:HL('Cursor', s:bg0, s:hls_cursor)
endfunction

function! BboxHlsHideCursor()
  call s:HL('Cursor', s:none, s:none, s:inverse)
endfunction

" }}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
