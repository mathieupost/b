set shell=/bin/sh

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let mapleader=" "
let maplocalleader="\\"

nnoremap ; :
nnoremap <A-;> ;

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

inoremap <f1> <esc>
nnoremap <f1> <esc>
cnoremap <f1> <esc>

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*/tmp/*,*.so,*.swp,*.zip

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

" make uses real tabs
au FileType make set noexpandtab

" au FileType go autocmd BufWritePre <buffer> silent Fmt

"au BufWritePost *.c,*.cpp,*.h silent! !ctags -R &
" au BufWritePost *.go silent! !sh -c "find . -name '*.go' | xargs gofmt 2>&1 >/dev/null"&

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby
au BufRead,BufNewFile {*.lua}    set ft=lua
au BufRead,BufNewFile {*.ronn}   set ft=markdown

au BufRead,BufNewFile */ruby/ruby/*.{c,h}    set sw=4 ts=8 softtabstop=8 noet

" Fish is close enough to sh that it's not so bad to just reuse that syntax.
au BufRead,BufNewFile {*.fish}    set ft=sh

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

au BufRead,BufNewFile *.txt call s:setupWrapping()

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
"let g:syntastic_quiet_warnings=1

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" % to bounce from do to end etc.
runtime! macros/matchit.vim

nnoremap <leader>s :%s/ \+$//ge<cr>:noh<cr>

set rnu
set nu
set numberwidth=1

nnoremap Q @q
vnoremap . :norm.<cr>

nmap <leader>j <leader>lb

nnoremap <leader>p Pjddkyy

au BufNewFile,BufRead *.handlebars set filetype=mustache

au BufNewFile,BufRead *.go set nolist

set notimeout
set ttimeout
set timeoutlen=50

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

map <C-\> :tnext<CR>

" more info on getting true colour working here: https://github.com/morhetz/gruvbox
colorscheme gruvbox
set bg=dark

nnoremap <leader>8 Orequire'debugger';debugger<esc>
nnoremap <leader>9 Orequire'pry';binding.pry<esc>

nnoremap Y yf$

inoremap <C-j> <esc>jli
inoremap <C-k> <esc>kli

nnoremap <C-0> :tn
nnoremap <C-9> :tp


set encoding=utf-8
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

"let g:ctrlp_max_height = 10
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}

nnoremap <leader>sv :source ~/.vimrc<cr>
nnoremap <leader>ev :edit ~/.vimrc<cr>

nnoremap <leader>n <C-^>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %^ <C-R>=expand('%')<cr>

inoremap kj <esc>
cnoremap kj <esc>
vnoremap kj <esc>

if has("mouse")
  set mouse=a
endif

if has("persistent_undo")
  set undodir=~/.vim/undodir
  set undofile
endif

set printfont=PragmataPro:h12

let g:airline_powerline_fonts = 1

nmap <leader>4 :NERDTreeToggle<cr>
nmap <leader>5 :TagbarToggle<cr>

au Filetype go set makeprg=go\ build\ ./...
nmap <leader>m :make<CR>:copen<CR>

set rtp+=/Users/burke/src/github.com/golang/lint/misc/vim

nmap T ddO

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1

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

set list listchars=tab:»·,trail:·
augroup trailing
  au!
  au InsertEnter * :set nolist listchars=
  au InsertLeave * :set list listchars=tab:»·,trail:·
augroup END

au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>e <Plug>(go-rename)

" let g:go_fmt_command = "goimports" " too slow :(

let g:syntastic_sh_shellcheck_args = ' -x'


"if quickscope gets annoying, https://gist.github.com/cszentkiralyi/dc61ee28ab81d23a67aa

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
"let g:go_auto_type_info = 1
"

