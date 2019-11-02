{ config, pkgs, ... }:

let
  shell-prompt = import ~/.dotfiles-src/shell-prompt/default.nix { pkgs = pkgs; };
  tmux-prompt  = import ~/.dotfiles-src/tmux-prompt/default.nix { pkgs = pkgs; };
in

{
  environment.systemPackages = with pkgs; [
    google-cloud-sdk
    htop
    tree
    zsh
    ruby_2_6
    jq
    fzf
    git
    ripgrep
    shell-prompt
    # tmux-prompt
  ];

  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;
  nix.maxJobs = 4;
  nix.buildCores = 4;
}
