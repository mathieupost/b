{ pkgs, ... }:

{
  vim-go-testify = pkgs.vimUtils.buildVimPlugin {
    name = "vim-go-testify";
    version = "2018-09-09";

    src = pkgs.fetchFromGitHub {
      owner = "rfratto";
      repo = "vim-go-testify";
      rev = "3452f4f47affb52d2dccd9cb327337de08f327b6";
      sha256 = "044f43m3h18mrc2b39b5zn7i0gggwr3cn3d65p14h8cd27jmwrws";
    };
  };

  gina = pkgs.vimUtils.buildVimPlugin {
    name = "gina";
    version = "2020-10-08";

    src = pkgs.fetchFromGitHub {
      owner = "lambdalisue";
      repo = "gina.vim";
      rev = "97116f338f304802ce2661c2e7c0593e691736f8";
      sha256 = "1j3sc6dpnwp4fipvv3vycqb77cb450nrk5abc4wpikmj6fgi5hk0";
    };
  };

  nuake = pkgs.vimUtils.buildVimPlugin {
    name = "nuake";
    version = "2019-07-18";

    src = pkgs.fetchFromGitHub {
      owner = "Lenovsky";
      repo = "nuake";
      rev = "db6738fad1e400a3ee84e522549bf7c2d9055dd6";
      sha256 = "07jvz7x6q0l9br6s4a50ki3sch0zljh5q8fr4kyfqk33dqv1h9d7";
    };
  };

  fzf-preview = pkgs.vimUtils.buildVimPlugin {
    name = "fzf-preview";
    version = "2020-11-02";

    src = pkgs.fetchFromGitHub {
      owner = "yuki-ycino";
      repo = "fzf-preview.vim";
      rev = "0be53dee7f22dd6bdc703d7d20a41212ec3ac01f";
      sha256 = "1a5fdvh6s0xbhck84yy6q25igqwwy7flpgqkb7ax8vpkw722lj2c";
    };
  };

  lazygit-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "lazygit-nvim";
    version = "2020-10-16";

    src = pkgs.fetchFromGitHub {
      owner = "kdheepak";
      repo = "lazygit.nvim";
      rev = "ddc9bffe0ff5be341430f69b65c7a669477adf5c";
      sha256 = "17nv98m9f09dypwv41hsrx0n734vnsn4sr0hqkjz4lfsjqpsp6hw";
    };
  };

  unfog = pkgs.vimUtils.buildVimPlugin {
    name = "unfog";
    version = "2020-08-16";

    src = pkgs.fetchFromGitHub {
      owner = "soywod";
      repo = "unfog.vim";
      rev = "0ee2103ca8a9b42002b5eae0e0a7f6309b25198a";
      sha256 = "1zbia70kflcs8dikfx9ixbgzia6l09bbpavh33mck9ylcn2dbwwq";
    };
  };
}
