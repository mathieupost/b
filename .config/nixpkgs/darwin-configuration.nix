{ config, pkgs, ... }:

let
  shell-prompt = import ~/.dotfiles-src/shell-prompt { pkgs = pkgs; };
  burkeutils   = import ~/.dotfiles-src/burkeutils { stdenvNoCC = pkgs.stdenvNoCC; };
in

{
  environment.systemPackages = with pkgs; [
    burkeutils
    fzf
    git
    ctags
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

  programs.nix-index.enable = true;

  # security.sandbox.profiles.kaleidoscope-relay.closure = [ pkgs.cacert pkgs.git ];
  # security.sandbox.profiles.kaleidoscope-relay.writablePaths = [ "/src/nixpkgs" ];
  # security.sandbox.profiles.kaleidoscope-relay.allowNetworking = true;

  # security.sandbox.profiles.poll-octobox = {
  #   closure = [ pkgs.cacert pkgs.ruby ];
  #   readablePaths = [
  #     "/usr/bin/security"
  #   ];
  #   writablePaths = [
  #     "/tmp/octobox-notifications"
  #     "/tmp/octobox"
  #     "/tmp/kbd-data"
  #   ];
  #   allowNetworking = true;
  # };

  # launchd.user.agents.poll-octobox = {
  #   command = "/usr/bin/sandbox-exec -f ${config.security.sandbox.profiles.fetch-nixpkgs-updates.profile} ${pkgs.ruby}/bin/ruby -C /src/nixpkgs fetch origin master";
  #   environment.HOME = "";
  #   environment.NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #   serviceConfig.KeepAlive = false;
  #   serviceConfig.ProcessType = "Background";
  #   serviceConfig.StartInterval = 360;
  # };

  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "right";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.mru-spaces = false;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  services.nix-daemon.enable = false;
  nix.useDaemon = false;
  programs.zsh.enable = true;
  system.stateVersion = 4;
  nix.maxJobs = 4;
  nix.buildCores = 4;
}
