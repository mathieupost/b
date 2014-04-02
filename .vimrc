if $SHELL =~ 'fish'
  set shell=/bin/sh
endif

" 256-color more. Necessary to make it work in console and macvim
set t_Co=256

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
set list listchars=tab:\ \ ,trail:·

" Make vim fast.
set synmaxcol=300
set ttyfast
set ttyscroll=3
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

au FileType go autocmd BufWritePre <buffer> silent Fmt

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

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

nnoremap <leader>5 :GundoToggle<cr>

nnoremap <leader>s :%s/ \+$//ge<cr>:noh<cr>

set rnu
set nu
set numberwidth=1

nnoremap <space> @q
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

set background=dark
let g:solarized_termtrans = 1
colorscheme solarized

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

" <A-l>
nnoremap ¬ :tabn<cr>
" <A-h>
nnoremap ˙ :tabp<cr>
" <A-n>
nnoremap ˜ :tabnew<cr>
" <A-w>
nnoremap ∑ :tabclose<cr>

nnoremap ∆ :m+<CR>==    " Option + j
nnoremap ˚ :m-2<CR>==   " Option + k
inoremap ∆ <Esc>:m+<CR>==gi
inoremap ˚ <Esc>:m-2<CR>==gi
vnoremap ∆ :m'>+<CR>gv=gv
vnoremap ˚ :m-2<CR>gv=gv

noremap H ^
noremap L $

autocmd FileType go  :iabbrev <buffer> ifep if err != nil { panic(err) }
autocmd FileType go  :iabbrev <buffer> ifer if err != nil { return err }
autocmd FileType go  :iabbrev <buffer> ifern if err != nil { return nil, err }

" let g:ctrlp_map = '<c-t>'
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_files = 20000

let g:ctrlp_max_height = 10

if has("mac")
  let g:path_to_matcher = "/Users/burke/bin/matcher"
else
  let g:path_to_matcher = "/home/burke/bin/matcher-linux"
end

let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']

let g:ctrlp_match_func = { 'match': 'GoodMatch' }

function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

  " Create a cache file if not yet exists
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif
  if !filereadable(cachefile)
    return []
  endif

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '
  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    let cmd = cmd.'--no-dotfiles '
  endif
  let cmd = cmd.a:str

  return split(system(cmd), "\n")

endfunction

nnoremap <leader>sv :source ~/.vimrc<cr>
nnoremap <leader>ev :edit ~/.vimrc<cr>

nnoremap <leader>n <C-^>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %^ <C-R>=expand('%')<cr>

inoremap kj <esc>
cnoremap kj <esc>
vnoremap kj <esc>

" Ack for the last search.
nnoremap <silent> <leader>? :execute "Ack! '" . substitute(substitute(substitute(@/, "\\\\<", "\\\\b", ""), "\\\\>", "\\\\b", ""), "\\\\v", "", "") . "'"<CR>

" Toggle paste
set pastetoggle=<F8>

if has("mouse")
  set mouse=a
endif

if has("persistent_undo")
  set undodir=~/.vim/undodir
  set undofile
endif

set printfont=PragmataPro:h12

function! PropagatePasteBufferToOSX()
  let @n=getreg("*")
  call system('pbcopy-remote', @n)
  echo "done"
endfunction

function! PopulatePasteBufferFromOSX()
  let @+ = system('pbpaste-remote')
  echo "done"
endfunction

nnoremap <leader>6 :call PopulatePasteBufferFromOSX()<cr>
nnoremap <leader>7 :call PropagatePasteBufferToOSX()<cr>

let g:airline_powerline_fonts = 1

"let g:gofmt_command = 'goimports'

let g:ackprg = 'ag --nogroup --nocolor --column'

let g:Powerline_theme='long'
let g:Powerline_colorscheme='solarized256_dark'
