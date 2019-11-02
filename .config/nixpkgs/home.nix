{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.broot = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };

  home.file.".gnupg/gpg-agent.conf".text = ''
    disable-scdaemon
    pinentry-program = ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  '';

  home.file.".config/LS_COLORS".text = builtins.readFile ./home/LS_COLORS;

  home.file.".crawlrc".text = ''
    runrest_stop_message += Your battlesphere wavers and loses cohesion.
    runrest_stop_message += You feel your bond with your battlesphere wane.
    show_travel_trail    = true
    travel_delay         = -1
    rest_delay           = -1
    explore_stop         = glowing_items, artefacts, runes
    explore_stop         += greedy_pickup_smart, greedy_sacrificeable
    explore_stop         += shops, altars, runed_doors
    explore_stop         += stairs, portals, branches
    explore_wall_bias    = 1
    trapwalk_safe_hp     = dart:20,needle:15,arrow:35,bolt:45,spear:40,axe:45,blade:95
    easy_eat_chunks      = true
    auto_eat_chunks      = true
    auto_drop_chunks     = never
    sort_menus           = true : charged,equipped,identified,curse,art,ego,glowing,freshness,>qty,basename
    autofight_stop       = 65
    hp_colour            = 100:lightgrey, 99:green, 75:yellow, 50:red
    force_more_message   += You are starting to lose your buoyancy
    force_more_message   += Space (bends|warps horribly) around you
    force_more_message   += danger:
    force_more_message   += Found a gateway leading out of the Abyss
    auto_sacrifice       = true
    may_stab_brand       = hi:green
  '';

  home.file.".ripgreprc".text = ''
    --max-columns=150
    --max-columns-preview
  '';

  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      extraOptions = {
        UseRoaming = "no";
        KexAlgorithms = "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256";
        HostKeyAlgorithms = "ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa";
        Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
        PubkeyAuthentication = "yes";
        MACs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com";
        PasswordAuthentication = "no";
        ChallengeResponseAuthentication = "no";
        # UseKeychain = "yes";
        AddKeysToAgent = "yes";
      };
    };

    matchBlocks.mini = {
      user = "administrator";
      hostname = "208.52.154.14";
    };

    matchBlocks.sb = {
      user = "root";
      port = 2222;
    };
  };

  programs.git = {
    enable = true;
    userName = "Burke Libbey";
    userEmail = "burke@libbey.me";
    extraConfig = {
      hub.protocol = "https";
      github.user = "burke";
      color.ui = true;
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      credential.helper = "osxkeychain";
      diff.algorithm = "patience";
      protocol.version = "2";
      url."https://github.com/Shopify/".insteadOf = [
        "git@github.com:Shopify/"
        "git@github.com:shopify/"
        "ssh://git@github.com/Shopify/"
        "ssh://git@github.com/shopify/"
      ];
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history = {
      path = "$HOME/.zsh_history";
      size = 50000;
      save = 50000;
    };
    shellAliases = {
      "do,s"  = "dev open shipit";
      "do,pr" = "dev open pr";

      "git-fuck-everything" = "git-abort ; git reset . ; git checkout . ; git clean -f -d";
      "mk" = "minikube";

      "ls" = "gls --color=auto -F";

      # Ubuntu / Remote {{{
      "scc"      = "sudo chef-client";
      "sagu"     = "sudo apt-get update";
      "acm"      = "apt-cache madison";
      "sagi"     = "sudo apt-get install";
      # }}}
      # u/uu/uuu/... {{{
      "u"        = "cd ..";
      "uu"       = "cd ../..";
      "uuu"      = "cd ../../..";
      "uuuu"     = "cd ../../../..";
      "uuuuu"    = "cd ../../../../..";
      "uuuuuu"   = "cd ../../../../../..";
      # }}}
      # ap1/ap2/... {{{
      "ap1"      = "ap 1";
      "ap2"      = "ap 2";
      "ap3"      = "ap 3";
      "ap4"      = "ap 4";
      "ap5"      = "ap 5";
      "ap6"      = "ap 6";
      "ap7"      = "ap 7";
      "ap8"      = "ap 8";
      "ap9"      = "ap 9";
      # }}}
      # Ruby / Bundler {{{
      "bi"       = "bundle install";
      "bo"       = "bundle open";
      "bu"       = "bundle update";
      "bs"       = "bundle show";
      "bx"       = "bundle exec";
      "mu"       = "gem uninstall";
      "mi"       = "gem install";

      # }}}
      # Projects {{{
      "shop"     = "dev cd shopify";
      "note"     = "ghb notes";
      "sruby"    = "gh ruby ruby";
      # }}}
      # Git {{{

      "grbom"    = "gcom && gfrom && git reset --hard FETCH_HEAD && gco - && git rebase master";
      "grbog"    = "grbom && gufg";

      "gb"       = "git branch";

      "gzb"      = "git branch -l | fzf | xargs git checkout";
      "gzt"      = "git tag -l | fzf | xargs git checkout";
      "gzd"      = "git branch -l | fzf | xargs git branch -d";
      "gzD"      = "git branch -l | fzf | xargs git branch -D";
      "gzri"     = "git log -30 --format=oneline | fzf | cut -d ' ' -f 1 | xargs git rebase -i";

      "grim"     = "git rebase -i master";
      "gtl"      = "git tag -l";
      "ga"       = "git add";
      "gap"      = "git add -p";
      "gaac"     = "git add -A .; gac";
      "gav"      = "git commit -av";
      "gbl"      = "git branch -l";
      "gbd"      = "git branch -D";
      "gu"       = "git push";
      "gut"      = "git push --tags";
      "gutf"     = "git push --tags -f";
      "gcaar"    = "git add -A .; git commit -a --reuse-message=HEAD --amend";
      "gcar"     = "git commit -a --reuse-message=HEAD --amend";
      "gco"      = "git checkout";
      "gcob"     = "git checkout -b";
      "gcom"     = "gco master";
      "gcp"      = "git cherry-pick";
      "gd"       = "git pull";
      "gf"       = "git diff";
      "gfc"      = "git diff --cached";
      "gl"       = "git log";
      "glr"      = "git log --reverse";
      "glp"      = "git log -p";
      "glpr"     = "git log -p --reverse";
      "gm"       = "git merge";
      "gn"       = "git clone";
      "gri"      = "git rebase -i";
      "grc"      = "git rebase --continue";
      "gra"      = "git rebase --abort";
      "gcpa"     = "git cherry-pick --abort";
      "gma"      = "git merge --abort";
      "gs"       = "git stash";
      "gsa"      = "git stash apply";
      "gsd"      = "git stash drop";
      "gsl"      = "git stash list";
      "gsp"      = "git stash pop";
      "gt"       = "git status -sb";
      "gwc"      = "git whatchanged";
      "gr"       = "git reset HEAD";
      "gr1"      = "git reset 'HEAD^'";
      "gr2"      = "git reset 'HEAD^^'";
      "gro"      = "git reset";
      "grh"      = "git reset --hard HEAD";
      "grh1"     = "git reset --hard 'HEAD^'";
      "grh2"     = "git reset --hard 'HEAD^^'";
      "grho"     = "git reset --hard";
      # }}}
      # Head / Tail {{{
      "h1"       = "h 1";
      "h2"       = "h 2";
      "h3"       = "h 3";
      "h4"       = "h 4";
      "h5"       = "h 5";
      "h6"       = "h 6";
      "h7"       = "h 7";
      "h8"       = "h 8";
      "h9"       = "h 9";
      "h10"      = "h 10";
      "h15"      = "h 15";
      "h20"      = "h 20";
      "h30"      = "h 30";
      "h40"      = "h 40";
      "h50"      = "h 50";
      "h60"      = "h 60";

      "t1"       = "t 1";
      "t2"       = "t 2";
      "t3"       = "t 3";
      "t4"       = "t 4";
      "t5"       = "t 5";
      "t6"       = "t 6";
      "t7"       = "t 7";
      "t8"       = "t 8";
      "t9"       = "t 9";
      "t10"      = "t 10";
      "t15"      = "t 15";
      "t20"      = "t 20";
      "t30"      = "t 30";
      "t40"      = "t 40";
      "t50"      = "t 50";
      "t60"      = "t 60";
      # }}}
      # {{{ dev
      "dld"      = "dev load-dev --no-backend";
      "dls"      = "dev load-system --no-backend";
      # }}}

      "mutt"     = "kick-gpg-agent && command mutt";
      "less"     = "/usr/bin/less -FXRS";
      "tmux"     = "/usr/bin/env TERM=screen-256color-bce tmux";
      "tree"     = "command tree -I 'Godep*' -I 'node_modules*'";

      "xk9"      = "xargs kill -9";
      "ka9"      = "killall -9";
      "k9"       = "kill -9";

      "m"        = "hostname-fix ; mutt";
      "a"        = "ag";
      "ai"       = "ag -i";
      "aa"       = "ag -a";
      "aai"      = "ag -ai";
      "g"        = "grep";
      "chx"      = "chmod +x";

      "ctr"      = "ctags -R .";
      "gtr"      = "gotags -R . > tags";

      "l1"       = "tree --dirsfirst -ChFL 1";
      "l2"       = "tree --dirsfirst -ChFL 2";
      "l3"       = "tree --dirsfirst -ChFL 3";
      "ll1"      = "tree --dirsfirst -ChFupDaL 1";
      "ll2"      = "tree --dirsfirst -ChFupDaL 2";
      "ll3"      = "tree --dirsfirst -ChFupDaL 3";
      "l"        = "l1";
      "ll"       = "ll1";
    };
    defaultKeymap = "emacs";
    initExtraBeforeCompInit = ''
      fpath=("$HOME/.zshrc.d/autocomplete" "$fpath[@]")

      # Prompt {{{
      PROMPT='$(shell-prompt "$?" "''${__shadowenv_data%%:*}")'
      setopt prompt_subst
      # }}}
      # GPG Agent {{{
      gpg-agent --daemon >/dev/null 2>&1
      function kick-gpg-agent {
        pid=$(ps xo pid,command | grep -E "^\d+ gpg-agent" | awk '{print $1}')
        export GPG_AGENT_INFO=$HOME/.gnupg/S.gpg-agent:''${pid}:1
      }
      kick-gpg-agent
      export GPG_TTY=$(tty)
      # }}}
      # Generic Configuration {{{
      gh() { cd  "$(gh  "$@")" }
      ghs() { cd "$(ghs "$@")" }
      ghb() { cd "$(ghb "$@")" }
      ]gs() { cd "$(]gs "$@")" }
      ]gb() { cd "$(]gb "$@")" }

      function ghs() {
        dev clone $1
      }

      eval $(/nix/var/nix/gcroots/coreutils/bin/dircolors -b ~/.config/LS_COLORS)

      # }}}
      # ZSH options and features {{{
      # If a command is issued that can’t be executed as a normal command, and the
      # command is the name of a directory, perform the cd command to that directory.
      setopt AUTO_CD

      # Treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename
      # generation, etc.  (An initial unquoted ‘~’ always produces named directory
      # expansion.)
      setopt EXTENDED_GLOB

      # If a pattern for filename generation has no matches, print an error, instead
      # of leaving it unchanged in the argument  list. This also applies to file
      # expansion of an initial ‘~’ or ‘=’.
      setopt NOMATCH

      # no Beep on error in ZLE.
      setopt NO_BEEP

      # Remove any right prompt from display when accepting a command line. This may
      # be useful with terminals with other cut/paste methods.
      setopt TRANSIENT_RPROMPT

      # If unset, the cursor is set to the end of the word if completion is started.
      # Otherwise it stays there and completion is done from both ends.
      setopt COMPLETE_IN_WORD

      setopt auto_pushd
      setopt append_history

      unsetopt MULTIOS
    '';

    initExtra = ''
      promptinit
      # zsh-mime-setup
      autoload colors
      colors
      autoload -Uz zmv # move function
      autoload -Uz zed # edit functions within zle
      zle_highlight=(isearch:underline)

      # Enable ..<TAB> -> ../
      zstyle ':completion:*' special-dirs true

      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

      typeset WORDCHARS="*?_-.~[]=&;!#$%^(){}<>"

      # }}}

      function git() {
        local toplevel=$(command git rev-parse --show-toplevel 2>/dev/null)
        if [[ "''${toplevel}" == "''${HOME}" ]] && [[ "$1" == "clean" ]]; then
          >&2 echo "Do NOT run git clean in this repository."
          return
        fi
        command git "$@"
      }

      function ]g() {
        dev cd "$@"
      }

      function ]gs() {
        dev cd "$@"
      }

      function ]gb() {
        dev cd "burke/$@"
      }

      function z() {
        local srcpath
        srcpath="$(
          awk -F ' *= *' '
            $1 == "[srcpath]" { sp = "yes" }
            sp && $1 == "default" { print $2; exit }
          ' < ~/.config/dev
        )"
        dev cd ''${srcpath}/$(ls ''${srcpath} | fzf --select-1 --query "$@")
      }

      function gogopr() {
        git add -A .
        git commit -a -m "$*"
        git push origin "$(git branch | grep '*' | awk '{print $2}')"
        dev open pr
      }

      zle-dev-open-pr() /opt/dev/bin/dev open pr
      zle -N zle-dev-open-pr
      bindkey 'ø' zle-dev-open-pr # Alt-O ABC Extended
      bindkey 'ʼ' zle-dev-open-pr # Alt-O Canadian English

      zle-dev-open-github() /opt/dev/bin/dev open github
      zle -N zle-dev-open-github
      bindkey '©' zle-dev-open-github # Alt-G ABC Extended & Canadian English

      zle-dev-open-shipit() /opt/dev/bin/dev open shipit
      zle -N zle-dev-open-shipit
      bindkey 'ß' zle-dev-open-shipit # Alt-S ABC Extended & Canadian English

      zle-dev-open-app() /opt/dev/bin/dev open app
      zle -N zle-dev-open-app
      bindkey '®' zle-dev-open-app # Alt-R ABC Extended & Canadian English

      zle-dev-cd(){ dev cd ''${''${(z)BUFFER}}; zle .beginning-of-line; zle .kill-line; zle .accept-line }
      zle -N zle-dev-cd
      bindkey '∂' zle-dev-cd # Alt-D Canadian English

      zle-dev-cd() {
        dev cd "''${''${(z)BUFFER}}"
        zle .beginning-of-line
        zle .kill-line
        zle .accept-line
      }
      zle -N zle-dev-cd
      bindkey '∂' zle-dev-cd # Alt-D Canadian English

      zle-checkout-branch() {
        local branch
        branch="$(git branch -l | fzf -f "''${''${(z)BUFFER}}" | awk '{print $1; exit}')" 
        git checkout "''${branch}" >/dev/null 2>&1
        zle .beginning-of-line
        zle .kill-line
        zle .accept-line
      }
      zle -N zle-checkout-branch
      bindkey '∫' zle-checkout-branch # Alt-B Canadian English

      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=3'

      export DEV_ALLOW_ITERM2_INTEGRATION=1
      source ~/.iterm2_shell_integration.zsh
      iterm2_print_user_vars() {
        iterm2_set_user_var gitBranch $(git rev-parse --abbr-ref HEAD 2> /dev/null)
      }

      source ~/.nix-profile/etc/profile.d/nix.sh
      export NIX_REMOTE=daemon
      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

      if [ -f /opt/dev/dev.sh ]; then
        source /opt/dev/dev.sh
      fi
      if [ -f ~/.acme.sh/acme.sh.env ]; then
        . "/Users/burke/.acme.sh/acme.sh.env"
      fi
    '';

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.3";
          sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
          sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
        };
      }
    ];

    sessionVariables = rec {
      NVIM_TUI_ENABLE_TRUE_COLOR = "1";
      DISABLE_SPRING = "0";
      OPT_SHOW = "1";
      OPT_ISEQ_CACHE = "0";
      OPT_AOT_RUBY = "1";
      OPT_AOT_YAML = "1";
      OPT_PRE_BOOTSCALE = "1";
      OPT_TOXIPROXY_CACHE = "1";

      RIPGREP_CONFIG_PATH = ~/.ripgreprc;

      BOOTSNAP_PEDANTIC = "1";

      EDITOR = "vim";
      VISUAL = EDITOR;
      GIT_EDITOR = EDITOR;
      XDG_CONFIG_HOME = "$HOME/.config";

      GOPATH = "$HOME";

      PATH = "$HOME/bin/_git:$HOME/bin:$PATH";
    };
    # envExtra
    # profileExtra
    # loginExtra
    # logoutExtra
    # localVariables
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./home/extraConfig.vim;

    plugins = with pkgs.vimPlugins; [
      # Syntax / Language Support ##########################
      vim-nix
      vim-ruby             # ruby
      vim-go               # go
      vim-fish             # fish
      # vim-toml           # toml
      # vim-gvpr           # gvpr
      rust-vim             # rust
      vim-pandoc           # pandoc (1/2)
      vim-pandoc-syntax    # pandoc (2/2)
      # yajs.vim           # JS syntax
      # es.next.syntax.vim # ES7 syntax

      # UI #################################################
      gruvbox              # colorscheme
      vim-gitgutter        # status in gutter
      # vim-devicons
      vim-airline

      # Editor Features ####################################
      vim-surround         # cs"'
      vim-repeat           # cs"'...
      vim-commentary       # gcap
      # vim-ripgrep
      vim-indent-object    # >aI
      vim-easy-align       # vipga
      vim-eunuch           # :Rename foo.rb
      # vim-endwise        # add end, } after opening block
      # gitv
      # tabnine-vim
      ale                  # linting
      # vim-toggle-quickfix
      # neosnippet.vim
      # neosnippet-snippets
      # splitjoin.vim

      # Buffer / Pane / File Management ####################
      fzf-vim              # all the things

      # Panes / Larger features ############################
      tagbar               # <leader>5
      vim-fugitive         # Gblame
    ];
  };
}
