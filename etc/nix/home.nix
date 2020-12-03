# vim: set foldmethod=indent:
{ config, pkgs, lib, ... }:

let
  callPackage = pkgs.callPackage;

  relativeXDGConfigPath = ".config";
  relativeXDGDataPath = ".local/share";
  relativeXDGCachePath = ".cache";

  doom-emacs = callPackage (builtins.fetchTarball {
    url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
  }) {
    doomPrivateDir = ./doom.d;  # Directory containing your config.el init.el
                                # and packages.el files
  };

  minidev = callPackage /b/src/minidev { };

  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    rev = "6fb72eecdcb533637f5a04ac635aa666b736cf50";
    sha256 = "0czqgizxq7ckmqw9xbjik7i1dfwgc1ci8fvp1fsddb35qrqi857a";
  };
  ls-colors = pkgs.runCommand "ls-colors" { } ''
    mkdir -p $out/bin $out/share
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
    ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
    cp ${LS_COLORS}/LS_COLORS $out/share/LS_COLORS
  '';
in {

  # home.packages = [ ls-colors minidev ];

  xdg.enable = true;
  xdg.configHome =
    "/Users/mathieu/${relativeXDGConfigPath}";
  xdg.dataHome = "/Users/mathieu/${relativeXDGDataPath}";
  xdg.cacheHome = "/Users/mathieu/${relativeXDGCachePath}";

  nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "20.09";

  home.sessionVariables = {
    # general
    PATH = "${config.home.sessionVariables.GOBIN}:$PATH";
    EDITOR = "vim";

    # go
    GOPATH = "${config.xdg.configHome}/Dev";
    GOBIN = "${config.home.sessionVariables.GOPATH}/bin";
    GO111MODULE = "on";
    GOPROXY = "goproxy.weave.nl";
    GONOSUMDB = "lab.weave.nl";

    GITLAB_PRIVATE_TOKEN = "i2eXfcEwjNzBtDCfrGw3";

    # fzf
    FZF_DEFAULT_OPTS = "--height 20% --bind ctrl-k:preview-up,ctrl-j:preview-down";
    # bat
    BAT_THEME = "gruvbox";
  };

  home.file.".emacs.d/init.el".text = ''
      (load "default.el")
  '';

  home.packages = with pkgs // pkgs.callPackage ./custom-go-packages.nix {}; [
    nix-prefetch-git
    haskellPackages.update-nix-fetchgit

    kitty
    doom-emacs

    coreutils
    fd  # find replacement written in Rust
    bat # cat replacement written in Rust
    jq  # parse json in the terminal
    htop

    # git/diff stuff
    # kdiff3
    lazygit
    gitAndTools.pre-commit
    gitAndTools.ydiff
    gitAndTools.delta

    ctags
    # bitwarden-cli
    # spotify
    # slack
    # duf       # disk usage/free utility
    timetrap  # tui time tracker
    neovim-remote
    nodePackages.yarn

    # go stuff
    goimports
    gofumpt
    golangci-lint

    # python
    python3
    pipenv

    # writing
    # texlive.combined.scheme-full
    
# 7  aur/asdf-vm         0.7.8-5        -> 0.8.0-1
# 2  aur/stack-client    2.6.4-2        -> 2.6.5-1
# 1  aur/workflowy       1.3.5_11085-1  -> 1.3.5_11275-1

  ];

  programs.fish = {
    enable = true;
    functions = {
      fish_title = "prompt_pwd";
    };
    shellInit = ''
      source (golangci-lint completion fish | psub)
    '';
    plugins = with pkgs.callPackage ./custom-fish-plugins.nix {}; [
      z
      fzf
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      cmd_duration.min_time = 500;
    };
  };

  programs.dircolors.enable = true;
  programs.direnv.enable = true;
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;
    extraConfig = ''
      scriptencoding utf-8
      set clipboard=unnamed
      set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
      set colorcolumn=100
      set list
      set nowrap
      " set breakindent
      " set breakindentopt=shift:8,min:40,sbr
      " set showbreak=>>
      set hidden            " Don't unload abandoned buffers
      set cmdheight=2       " Give more space for displaying messages
      set updatetime=300    " Faster CursorHold and swp file saving
      set shortmess+=c      " Disable messages
      set smartcase         " Smart case search
      set ignorecase
      set autoread          " Reload file on external changes
      set number            " Enable line numbers
      set signcolumn=yes    " Always enable sign column
      set mouse=a           " Enable mouse support
      set virtualedit=block " Enable block selection where there are no characters

      " Open files in the current neovim instance
      let $EDITOR = 'nvr'

      " TODO terminal stuff https://github.com/camspiers/dotfiles/blob/44c25ae6e0ce6cbf954d5df119806127ffff6a0d/files/.config/nvim/plugin/openterm.vim
      func! s:afterTermClose() abort
        bdelete!
      endfunc

      " Git related stuff
      augroup git
        autocmd!
        " Delete the buffers if they are git related
        autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
        " Return to lazygit with q
        autocmd FileType gitcommit,gitrebase,gitconfig nnoremap <silent> <buffer> q :bn<CR>i<CR>
        " Close lazygit buffer after exiting lazygit
        autocmd TermClose term://.//*:lazygit* call timer_start(20, { -> s:afterTermClose() })
      augroup end

      augroup terminal
        autocmd!
        autocmd TermOpen * setlocal nonumber
        autocmd TermOpen * setlocal signcolumn=no
        autocmd TermClose * nnoremap <silent> <buffer> q <C-^>:bd! #<CR>
        autocmd TermClose * tnoremap <silent> <buffer> q <C-\><C-n><C-^>:bd! #<CR>
      augroup end

      " Theme
      colorscheme gruvbox
      let g:gruvbox_contrast_light="hard"

      " Set min size of main window and distribute remaining space
      setlocal winwidth=80
      " setlocal winheight=20
      autocmd WinEnter * exe "normal \<C-w>="

      " persist last buffer location
      autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

      " persist buffer folds
      set foldmethod=syntax
      augroup folds
        autocmd!
        autocmd BufWinLeave *.* mkview
        autocmd BufWinEnter *.* silent! loadview
      augroup END

      let g:mapleader = "\<Space>"
      let g:maplocalleader = ','
      nnoremap <silent> <C-/> :nohlsearch<CR>
      nnoremap <silent> <F4> :Nuake<CR>
      inoremap <silent> <F4> <C-\><C-n>:Nuake<CR>
      tnoremap <silent> <F4> <C-\><C-n>:Nuake<CR>

      let g:animate#duration = 100.0
    '';
    plugins = with pkgs.vimPlugins // pkgs.callPackage ./custom-vim-plugins.nix {}; [
      vim-fish
      rainbow
      tagbar
      vim-surround
      vim-repeat
      vim-eunuch # Helpers for UNIX
      vim-commentary
      vim-unimpaired
      coc-git
      coc-tabnine
      traces-vim # highlights patterns and ranges
      # unfog
      vim-orgmode
      gina
      fzf-vim
      gruvbox
      nuake
      editorconfig-vim
      coc-snippets
      coc-pairs
      coc-json
      vim-go-testify

      {
        plugin = vim-nix;
        config = ''
          " A helper to preserve the cursor location with filters
          function! UpdateNixFetchGit()
            let w = winsaveview()
            execute "%!update-nix-fetchgit --location=" . line(".") . ":" . col(".")
            call winrestview(w)
          endfunction

          autocmd FileType nix nnoremap <silent> <buffer> <localleader> :<C-u>WhichKey! g:nix_localleader_map<CR>
          autocmd FileType nix vnoremap <silent> <buffer> <localleader> :<C-u>WhichKeyVisual! g:nix_localleader_map<CR>

          let g:nix_localleader_map = {
          \ 'u' : [':call UpdateNixFetchGit()' , 'UpdateNixFetchGit' ],
          \}
        '';
      }

      {
        plugin = coc-go;
        config = ''
          autocmd FileType go nnoremap <silent> <buffer> <localleader> :<C-u>WhichKey! g:go_localleader_map<CR>
          autocmd FileType go vnoremap <silent> <buffer> <localleader> :<C-u>WhichKeyVisual! g:go_localleader_map<CR>

          let g:go_localleader_map = {
          \ 'c' : {
          \   'name' : '+code' ,
          \   'r' : ['<Plug>(coc-rename)'                , 'rename'  ],
          \   'f' : [':call CocAction("format")'         , 'format'  ],
          \   'i' : [':call CocAction("organizeImport")' , 'imports' ],
          \  },
          \ 'f' : {
          \   'name' : '+file' ,
          \   't' : [':CocCommand go.test.toggle' , 'toggle-test' ],
          \  },
          \ 'g' : {
          \   'name' : '+generate' ,
          \   'k' : ['GoKeyify'                   , 'keyify'          ],
          \   'f' : ['GoFillStruct'               , 'fill-struct'     ],
          \   'e' : ['GoIfErr'                    , 'if-err'          ],
          \   'i' : [':CocCommand go.impl.cursor' , 'interface-stubs' ],
          \  },
          \ 't' : {
          \   'name' : '+test' ,
          \   'f' : [':e term://gotest %' , 'file' ],
          \  }
          \}
        '';
      }

      {
        plugin = vim-go;
        config = ''
          autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 
          autocmd FileType go let b:go_fmt_options = {
            \ 'goimports': '-local ' .
              \ trim(system('cd '. shellescape(expand('%:h')) .' && go list -m;')),
            \ }
          let g:go_fmt_autosave = 0
          let g:go_fmt_command = "goimports"
          let g:go_gopls_enabled = 0
          " Disable all key mappings
          let g:go_def_mapping_enabled = 0
          let g:go_doc_keywordprg_enabled = 0
          " let g:go_textobj_enabled = 0
          " Better highlighting
          let g:go_highlight_structs = 1 
          let g:go_highlight_types = 1 
          let g:go_highlight_fields = 1 
          let g:go_highlight_methods = 1
          let g:go_highlight_functions = 1
          let g:go_highlight_function_calls = 1
          let g:go_highlight_operators = 1
          let g:go_highlight_build_constraints = 1
        '';
      }

      {
        plugin = coc-nvim;
        config = ''
          " Use tab for trigger completion with characters ahead and navigate.
          inoremap <silent><expr> <TAB>
            \ pumvisible() ? coc#_select_confirm() :
            \ coc#expandableOrJumpable() ? '\<C-r>=coc#rpc#request("doKeymap", ["snippets-expand-jump",""])\<CR>' :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          let g:coc_snippet_next = '<TAB>'

          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <c-space> to trigger completion.
          if has('nvim')
            inoremap <silent><expr> <c-space> coc#refresh()
          else
            inoremap <silent><expr> <c-@> coc#refresh()
          endif

          " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
          " position. Coc only does snippet and additional edit on confirm.
          " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
          if exists('*complete_info')
            inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
          else
            inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
          endif

          " Use `[g` and `]g` to navigate diagnostics
          " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
          nmap <silent> [g <Plug>(coc-diagnostic-prev)
          nmap <silent> ]g <Plug>(coc-diagnostic-next)

          " GoTo code navigation.
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Use K to show documentation in preview window.
          nnoremap <silent> K :call <SID>show_documentation()<CR>

          function! s:show_documentation()
            if (index(['vim','help'], &filetype) >= 0)
              execute 'h '.expand('<cword>')
            else
              call CocActionAsync('doHover')
            endif
          endfunction

          " Highlight the symbol and its references when holding the cursor.
          autocmd CursorHold * silent call CocActionAsync('highlight')

          augroup mygroup
            autocmd!
            " Setup formatexpr specified filetype(s).
            autocmd FileType go,json setl formatexpr=CocAction('formatSelected')
            " Update signature help on jump placeholder.
            autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          augroup end
        '';
      }

      {
        plugin = vim-airline;
        config = ''
          let g:airline_powerline_fonts = 1
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
          let g:airline#extensions#battery#enabled = 1
          let g:airline#extensions#tagbar#enabled = 1
          let g:airline#extensions#coc#enabled = 1
          let g:airline#extensions#hunks#coc_git = 1
        '';
      }

      { 
        plugin = vim-which-key;
        config = ''
          packadd vim-which-key
          call which_key#register(g:mapleader, "g:which_key_leader_map")
          nnoremap <silent> <leader> :<C-u>WhichKey g:mapleader<CR>
          vnoremap <silent> <leader> :<C-u>WhichKeyVisual g:mapleader<CR>

          function! SearchWord()
            execute 'Rg' expand('<cword>')
          endfunction

          let g:which_key_leader_map = {}
          let g:which_key_leader_map[':'] = ['Commands', 'commands']
          let g:which_key_leader_map[' '] = ['History', 'recent-files']
          let g:which_key_leader_map['*'] = [':call SearchWord()', 'search-word']
          let g:which_key_leader_map['b'] = {
          \ 'name' : '+buffers' ,
          \ 'b' : ['Buffers'   , 'list-buffers'    ],
          \ '/' : ['<C-^>'     , 'other-buffer'    ],
          \ 'd' : [':bp|bd #'  , 'delete-buffer'   ],
          \ 'f' : ['bfirst'    , 'first-buffer'    ],
          \ 'l' : ['blast'     , 'last-buffer'     ],
          \ 'n' : ['bnext'     , 'next-buffer'     ],
          \ 'p' : ['bprevious' , 'previous-buffer' ],
          \ }
          let g:which_key_leader_map['w'] = {
          \ 'name' : '+windows' ,
          \ 'w' : ['Windows'    , 'list-windows'        ],
          \ '/' : ['<C-w>w'     , 'other-window'        ],
          \ 'd' : ['<C-w>c'     , 'delete-window'       ],
          \ 'h' : ['<C-w>h'     , 'window-left'         ],
          \ 'j' : ['<C-w>j'     , 'window-below'        ],
          \ 'l' : ['<C-w>l'     , 'window-right'        ],
          \ 'k' : ['<C-w>k'     , 'window-up'           ],
          \ 'H' : ['<C-w>5<'    , 'expand-window-left'  ],
          \ 'J' : [':resize +5' , 'expand-window-below' ],
          \ 'L' : ['<C-w>5>'    , 'expand-window-right' ],
          \ 'K' : [':resize -5' , 'expand-window-up'    ],
          \ '=' : ['<C-w>='     , 'balance-window'      ],
          \ 's' : ['<C-w>s'     , 'split-window-below'  ],
          \ 'v' : ['<C-w>v'     , 'split-window-below'  ],
          \ }
          let g:which_key_leader_map['f'] = {
          \ 'name' : '+files' ,
          \ 'f' : ['Files'               , 'find'             ],
          \ 's' : ['w'                   , 'save'             ],
          \ 'u' : [':<C-u>UndotreeToggle' , 'undo-tree-toggle' ],
          \ }
          let g:which_key_leader_map['o'] = {
          \ 'name' : '+open' ,
          \ 't' : ['Nuake' , 'terminal' ],
          \ }
          let g:which_key_leader_map['q'] = {
          \ 'name' : '+quit' ,
          \ 'q' : ['qa' , 'quit-all' ],
          \ }
          let g:which_key_leader_map['g'] = {
          \ 'name' : '+git' ,
          \ 'l' : [':tabe term://lazygit | startinsert' , 'lazygit' ],
          \ 'i' : ['<Plug>(coc-git-chunkinfo)' , 'chunkinfo' ],
          \ ']' : ['<Plug>(coc-git-nextchunk)' , 'nextchunk' ],
          \ '[' : ['<Plug>(coc-git-prevchunk)' , 'prevchunk' ],
          \ }
        '';
      }

      {
        plugin = undotree;
        config = ''
          " Protect changes between writes. Default values of
          " updatecount (200 keystrokes) and updatetime
          " (4 seconds) are fine
          set swapfile
          set directory^=~/.config/vim/swap//

          " protect against crash-during-write
          set writebackup
          " but do not persist backup after successful write
          set nobackup
          " use rename-and-write-new method whenever safe
          set backupcopy=auto
          set backupdir^=~/.config/vim/backup//

          " persist the undo tree for each file
          set undofile
          set undodir^=~/.config/vim/undo//
        '';
      }
    ];
  };
  # programs.bat.enable = true;
  # programs.broot.enable = true;
  # programs.gpg.enable = true;

  # home.file.".gnupg/gpg-agent.conf".text = ''
  #   disable-scdaemon
  # '' + (if pkgs.stdenv.isDarwin then ''
  #   pinentry-program = ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  # '' else
  #   "");

  # home.file.".config/karabiner/karabiner.json".source = ./home/karabiner.json;

  # home.file.".crawlrc".source = ./home/crawlrc;

  # home.file.".iterm2_shell_integration.zsh".source =
  #   ./home/.iterm2_shell_integration.zsh;

  # home.file.".config/nvim/backup/.keep".text = "";

  # home.file.".hammerspoon".source = /b/etc/hammerspoon;
  # home.file."Documents/Arduino/Model01-Firmware".source =
  #   /b/src/Model01-Firmware;

  # home.file."Library/LaunchAgents/mathieu.gitpull.plist".source =
  #   ./home/mathieu.gitpull.plist;

  # programs.ssh = {
  #   enable = true;
  #   # matchBlocks."*" = {
  #   #   extraOptions = {
  #   #     UseRoaming = "no";
  #   #     KexAlgorithms =
  #   #       "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256";
  #   #     HostKeyAlgorithms =
  #   #       "ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa";
  #   #     Ciphers =
  #   #       "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
  #   #     PubkeyAuthentication = "yes";
  #   #     MACs =
  #   #       "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com";
  #   #     PasswordAuthentication = "no";
  #   #     ChallengeResponseAuthentication = "no";
  #   #     # UseKeychain = "yes";
  #   #     AddKeysToAgent = "yes";
  #   #   };
  #   # };

  #   matchBlocks.tanagra = {
  #     hostname = "192.168.1.45";
  #     port = 2222;
  #     extraOptions = { PasswordAuthentication = "yes"; };
  #   };
  #   matchBlocks.nix = { hostname = "138.197.155.9"; };
  #   matchBlocks.sb = {
  #     hostname = "144.217.224.247";
  #     user = "root";
  #     port = 2222;
  #   };
  # };

  # programs.git = {
  #   enable = true;
  #   userName = "Mathieu Post";
  #   userEmail = "mathieupost@gmail.com";
  #   extraConfig = {
  #     hub.protocol = "https";
  #     github.user = "mathieupost";
  #     color.ui = true;
  #     pull.rebase = true;
  #     merge.conflictstyle = "diff3";
  #     credential.helper = "osxkeychain";
  #     diff.algorithm = "patience";
  #     protocol.version = "2";
  #     core.commitGraph = true;
  #     gc.writeCommitGraph = true;
  #     # url."https://github.com/Shopify/".insteadOf = [
  #     #   "git@github.com:Shopify/"
  #     #   "git@github.com:shopify/"
  #     #   "ssh://git@github.com/Shopify/"
  #     #   "ssh://git@github.com/shopify/"
  #     # ];
  #   };
  # };

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   enableAutosuggestions = true;
  #   history = {
  #     path = "${relativeXDGDataPath}/zsh/.zsh_history";
  #     size = 50000;
  #     save = 50000;
  #   };
  #   shellAliases = import ./home/aliases.nix;
  #   defaultKeymap = "emacs";
  #   initExtraBeforeCompInit = ''
  #     eval $(${pkgs.coreutils}/bin/dircolors -b ${./home/LS_COLORS})
  #     ${builtins.readFile ./home/pre-compinit.zsh}
  #   '';
  #   initExtra = builtins.readFile ./home/post-compinit.zsh;

  #   plugins = [
  #     {
  #       name = "zsh-autosuggestions";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zsh-users";
  #         repo = "zsh-autosuggestions";
  #         rev = "v0.6.3";
  #         sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
  #       };
  #     }
  #     {
  #       name = "zsh-syntax-highlighting";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zsh-users";
  #         repo = "zsh-syntax-highlighting";
  #         rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
  #         sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
  #       };
  #     }
  #   ];

  #   sessionVariables = rec {
  #     NVIM_TUI_ENABLE_TRUE_COLOR = "1";

  #     HOME_MANAGER_CONFIG = /b/etc/nix/home.nix;

  #     ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3";
  #     DEV_ALLOW_ITERM2_INTEGRATION = "1";

  #     EDITOR = "vim";
  #     VISUAL = EDITOR;
  #     GIT_EDITOR = EDITOR;

  #     GOPATH = "$HOME";

  #     PATH = "$HOME/.emacs.d/bin:$HOME/bin:$PATH";
  #   };
  #   # envExtra
  #   # profileExtra
  #   # loginExtra
  #   # logoutExtra
  #   # localVariables
  # };

  # programs.neovim = {
  #   enable = true;
  #   vimAlias = true;
  #   extraConfig = builtins.readFile ./home/extraConfig.vim;

  #   plugins = with pkgs.vimPlugins; [
  #     # Syntax / Language Support ##########################
  #     vim-nix
  #     vim-ruby # ruby
  #     vim-go # go
  #     vim-fish # fish
  #     # vim-toml           # toml
  #     # vim-gvpr           # gvpr
  #     rust-vim # rust
  #     vim-pandoc # pandoc (1/2)
  #     vim-pandoc-syntax # pandoc (2/2)
  #     # yajs.vim           # JS syntax
  #     # es.next.syntax.vim # ES7 syntax

  #     # UI #################################################
  #     gruvbox # colorscheme
  #     vim-gitgutter # status in gutter
  #     # vim-devicons
  #     vim-airline

  #     # Editor Features ####################################
  #     vim-surround # cs"'
  #     vim-repeat # cs"'...
  #     vim-commentary # gcap
  #     # vim-ripgrep
  #     vim-indent-object # >aI
  #     vim-easy-align # vipga
  #     vim-eunuch # :Rename foo.rb
  #     vim-sneak
  #     supertab
  #     # vim-endwise        # add end, } after opening block
  #     # gitv
  #     # tabnine-vim
  #     ale # linting
  #     nerdtree
  #     # vim-toggle-quickfix
  #     # neosnippet.vim
  #     # neosnippet-snippets
  #     # splitjoin.vim
  #     nerdtree

  #     # Buffer / Pane / File Management ####################
  #     fzf-vim # all the things

  #     # Panes / Larger features ############################
  #     tagbar # <leader>5
  #     vim-fugitive # Gblame
  #   ];
  # };
}
