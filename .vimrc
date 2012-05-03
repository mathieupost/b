" 256-color more. Necessary to make it work in console and macvim
set t_Co=256

" Speed things up.
set nocompatible

let mapleader = ","

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

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

" make uses real tabs
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

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
let g:syntastic_quiet_warnings=1

" gist-vim defaults
if has("mac")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" % to bounce from do to end etc.
runtime! macros/matchit.vim


let g:EasyMotion_leader_key = '<leader><leader>'
nnoremap <leader>4 :TagbarToggle<cr>
nnoremap <leader>5 :GundoToggle<cr>
let g:Powerline_symbols = 'fancy'
" let g:Powerline_cache_enabled = 0
let g:Powerline_colorscheme = 'solarized' " https://raw.github.com/gist/2003862/e245d6d9b60b16ea38d384107401ef9ad04fbb47/solarized.vim

nnoremap <leader>s :%s/ \+$//g<cr>:noh<cr>


function! ToggleNuMode()
  if(&rnu == 1)
    set nu
  else
    set rnu
  endif
endfunction
nnoremap <leader><leader>n :call ToggleNuMode()<cr>
au BufReadPost * set relativenumber

nnoremap <space> @q

nmap <leader>j <leader>lb

nnoremap <leader>p Pjddkyy

au BufNewFile,BufRead *.handlebars set filetype=mustache

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

" Convert symbol to string
nmap ,v lF:xysiw'
" Convert string to symbol
nmap ,V ds'i:<esc>

" Edit related test
" nnoremap <leader>5 <C-w>v<C-w>l:A<cr>

nnoremap <leader>8 Orequire'ruby-debug';debugger<esc>
nnoremap <leader>9 Orequire'pry';binding.pry<esc>

nnoremap Y yf$

inoremap <C-j> <esc>jli
inoremap <C-k> <esc>kli
inoremap <C-e> <esc>A
inoremap <C-a> <esc>I
nnoremap <C-e> $
nnoremap <C-a> ^

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

let g:ctrlp_map = '<c-t>'
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_files = 20000

let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git/', 'cd %s && git ls-files'],
    \ },
  \ 'fallback': 'find %s -type f'
  \ }

let g:ctrlp_dotfiles = 0
function! g:GoodMatch(items, str, limit, mmode, ispath, crfile, regex)
  " the Command-T matcher doesn't do regex. Return now if that was requested.
  if a:regex == 1
    let [lines, id] = [[], 0]
    for item in a:items
      let id += 1
      try | if !( a:ispath && item == a:crfile ) && (match(item, a:str) >= 0)
        cal add(lines, item)
      en | cat | brea | endt
    endfo
    return lines
  end

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = "/Users/burke/matcher/matcher --limit " . a:limit . " --manifest " . ctrlp#utils#cachefile() . " "
  if ! g:ctrlp_dotfiles
    let cmd = cmd . "--no-dotfiles "
  endif
  let cmd = cmd . a:str
  return split(system(cmd))

endfunction
let g:ctrlp_match_func = { 'match': 'g:GoodMatch' }

"nnoremap <leader>gR :call ShowRoutes()<cr>
nnoremap <leader>gg :CommandTFlush<cr>\|:CommandT<cr>
nnoremap <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
nnoremap <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
nnoremap <leader>gb :CommandTFlush<cr>\|:CommandT app/behaviours<cr>
nnoremap <leader>gd :CommandTFlush<cr>\|:CommandT app/decorators<cr>
nnoremap <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
nnoremap <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
nnoremap <leader>ga :CommandTFlush<cr>\|:CommandT app/assets<cr>
nnoremap <leader>gp :CommandTFlush<cr>\|:CommandT app/presenters<cr>
nnoremap <leader>gP :CommandTFlush<cr>\|:CommandT public<cr>
nnoremap <leader>gr :topleft 100 :split config/routes.rb<cr>
nnoremap <leader>gG :topleft 100 :split Gemfile<cr>

nnoremap <leader>sv :source ~/.vimrc.local<cr>
nnoremap <leader>ev :edit ~/.vimrc.local<cr>

nnoremap <leader>n <C-^>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
cnoremap %! <C-R>=expand('%')<cr>

" <leader>F maps <leader>f to run the current spec.
function! MapSpecRun(file)
  execute "nnoremap <leader>f :w\\|:!rspec -c -fp ".a:file."<cr>"
endfunction
nnoremap <leader>F :call MapSpecRun("<C-R>=expand('%')<cr>")<cr>

set statusline=%F%m%r%h%w\ <%Y>\ %l:%v(%L\|%p%%)

inoremap kj <esc>
cnoremap kj <esc>
vnoremap kj <esc>

nnoremap ; :

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
command! Rename call RenameFile()

if has("mouse")
  set mouse=a
endif

if has("persistent_undo")
  set undodir=~/.vim/undodir
  set undofile
endif

command! Gshop  cd ~/src/s/shopify
command! Grails cd ~/src/g/rails
command! Gruby  cd ~/src/g/ruby
command! Lshop  lcd ~/src/s/shopify
command! Lrails lcd ~/src/g/rails
command! Lruby  lcd ~/src/g/ruby

