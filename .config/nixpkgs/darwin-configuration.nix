{ config, pkgs, ... }:

let
  shell-prompt = import ~/.dotfiles-src/shell-prompt/default.nix { pkgs = pkgs; };
in

{
  environment.systemPackages = with pkgs; [
    fzf
    git
    google-cloud-sdk
    htop
    jq
    pinentry_mac
    ripgrep
    ruby_2_6
    shell-prompt
    tree
    zsh
  ];

  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;
  nix.maxJobs = 4;
  nix.buildCores = 4;
}
