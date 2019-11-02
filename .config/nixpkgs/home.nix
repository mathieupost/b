{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
