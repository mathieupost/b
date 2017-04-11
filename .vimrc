" vim: set foldmethod=marker:

set shell=/bin/sh

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let mapleader=" "
let maplocalleader="\\"

" Speed things up.
set nocompatible

set clipboard=unnamed
call pathogen#infect()

syntax on

" Disable beeps and flashes
set noeb vb t_vb=

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Make vim fast.
set synmaxcol=300
set ttyfast
" set ttyscroll=3 " gone in neovim
set lazyredraw

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*/tmp/*,*.so,*.swp,*.zip

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Remember last location in file
augroup remember_last_location
  au!
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
augroup END

function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

let g:python_host_prog = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

augroup makefile
  au!
  au FileType make set noexpandtab
augroup END

augroup golang
  au!
  au BufNewFile,BufRead *.go set nolist
  au Filetype go set makeprg=go\ build\ ./...
augroup END

augroup mode_extras
  au!
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,config.ru} set ft=ruby
  au BufRead,BufNewFile *.lua  set ft=lua
  au BufRead,BufNewFile *.ronn set ft=markdown
  au BufNewFile,BufRead *.json set ft=javascript
augroup END

augroup misc_indentation_and_wrapping
  au!
  au BufRead,BufNewFile {*.txt,*.md} call s:setupWrapping()
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79
  au BufRead,BufNewFile */ruby/ruby/*.{c,h}    set sw=4 ts=8 softtabstop=8 noet
augroup END

" Neovim takes a different approach to initializing the GUI. As It seems some
" Syntax and FileType autocmds don't get run all for the first file specified
" on the command line.  hack sidesteps that and makes sure we get a chance to
" get started. See https://github.com/neovim/neovim/issues/2953
if has('nvim')
  augroup nvim
    au!
    au VimEnter * doautoa Syntax,FileType
  augroup END
endif

augroup pandoc
  au!
  au FileType pandoc,markdown set textwidth=100 tabstop=8
  au FileType pandoc,markdown let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
  au Syntax pandoc,markdown syntax sync fromstart
augroup END
let g:pandoc#syntax#codeblocks#embeds#langs = ["c", "ruby", "bash=sh", "diff", "dot"]

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" % to bounce from do to end etc.
runtime! macros/matchit.vim

nnoremap ; :
nnoremap <A-;> ;
inoremap <f1> <esc>
nnoremap <f1> <esc>
cnoremap <f1> <esc>

nnoremap Q @q
vnoremap . :norm.<cr>
" remove trailing space from file
nnoremap <leader>s :%s/ \+$//ge<cr>:noh<cr>
nnoremap <leader>s :syntax sync fromstart<CR>
nnoremap <leader>p Pjddkyy

noremap  <C-\> :tnext<CR>

nnoremap <leader>9 Orequire'pry';binding.pry<esc>

nnoremap Y yf$

inoremap <C-j> <esc>jli
inoremap <C-k> <esc>kli

nnoremap <C-0> :tn
nnoremap <C-9> :tp

nnoremap <leader><space> :noh<cr>

cnoremap w!! %!sudo tee > /dev/null %

nnoremap <tab> %
vnoremap <tab> %

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" THANKS NEOVIM
nnoremap <bs> <C-w>h

" <A-l>
nnoremap ¬ :tabn<cr>
" <A-h>
nnoremap ˙ :tabp<cr>
" <A-t>
nnoremap † :tabnew<cr>
" <A-w>
nnoremap ∑ :tabclose<cr>

" <A-j>
nnoremap ∆ :m+<CR>==    " Option + j
inoremap ∆ <Esc>:m+<CR>==gi
vnoremap ∆ :m'>+<CR>gv=gv

" <A-k>
nnoremap ˚ :m-2<CR>==   " Option + k
inoremap ˚ <Esc>:m-2<CR>==gi
vnoremap ˚ :m-2<CR>gv=gv

noremap H ^
noremap L $

nnoremap <leader>sv :source ~/.vimrc<cr>
nnoremap <leader>ev :edit ~/.vimrc<cr>

nnoremap <leader>n <C-^>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %^ <C-R>=expand('%')<cr>

inoremap kj <esc>
cnoremap kj <esc>
vnoremap kj <esc>

nnoremap <leader>5 :GitGutterToggle<cr>
nnoremap <leader>5 :TagbarToggle<cr>

nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

nnoremap <leader>m :make<CR>:copen<CR>

nnoremap T ddO

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" {{{ FZF
set rtp+=/usr/local/opt/fzf

nnoremap <leader>j :Buffers<cr>
nnoremap <leader><C-p> :Files<cr>
nnoremap <leader><C-s> :GFiles?<cr>
nnoremap <C-p> :GFiles<cr>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>T :BTags<cr>

" Also useful: :Ag, :Marks, :History, :History/, :Commits, :BCommits

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" }}}

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

nnoremap <leader>6 *#:redraw<cr>:%s/<C-r><C-w>//gc<left><left><left>

set rnu
set nu
set numberwidth=1

set notimeout
set ttimeout
set timeoutlen=50

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

colorscheme jellybeans

set scrolloff=3
set autoindent
set autoread
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set nocursorline
set ruler
set backspace=indent,eol,start
set laststatus=2

if has("mouse")
  set mouse=a
endif

if has("persistent_undo")
  set undodir=~/.vim/undodir
  set undofile
endif

let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

set printfont=PragmataPro:h12


" {{{ LightLine

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '⭤' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? branch : ''
  endif
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" }}}

set rtp+=/Users/burke/src/github.com/golang/lint/misc/vim

" {{{ supertab configuration
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
" }}}

" {{{ tagbar configuration
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

if executable('ripper-tags')
    let g:tagbar_type_ruby = {
                \ 'kinds' : [
                    \ 'm:modules',
                    \ 'c:classes',
                    \ 'f:methods',
                    \ 'F:singleton methods',
                    \ 'C:constants',
                    \ 'a:aliases'
                \ ],
                \ 'ctagsbin':  'ripper-tags',
                \ 'ctagsargs': ['-f', '-']
                \ }
endif
" }}}

set list listchars=tab:»·,trail:·

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

let g:rustfmt_autosave = 1
