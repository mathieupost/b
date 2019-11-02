{ config, pkgs, ... }:

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
  ];

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.stateVersion = 4;
  nix.maxJobs = 4;
  nix.buildCores = 4;
}
