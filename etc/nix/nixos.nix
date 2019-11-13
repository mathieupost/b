let

  home-manager = builtins.fetchTarball {
    # latest 19.03 release as of 2019-06-11
    url = "https://github.com/rycee/home-manager/archive/4f13f06b016d59420cafe34915abdd6b795d3416.tar.gz";
    sha256 = "1chl04jimba1n1r4cqaq66kry4fy2xgsdgbqcl3rkw4ykd5yfcsc";
  };

  secrets = import /b/secrets/secrets.nix;

  burke-ed25519 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjexceqtvEjM22RZNVwjD6WhtEvVtolIaXnc14zK5Wj burke@darmok";

in

{ config, pkgs, ... }: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/networking.nix # generated at runtime by nixos-infect
    "${home-manager}/nixos"
    /b/src/perkeepd.nix
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-19.03;
  system.autoUpgrade.flags = [ "-I" "nixpkgs=/home/burke/src/nixpkgs" ];


  environment.systemPackages = with pkgs; [ home-manager htop git perkeep tree ];

  boot.cleanTmpDir = true;
  boot.loader.grub.device = "nodev";

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  networking = {
    hostName = "nix";
    nameservers = [ "8.8.8.8" ];
    firewall = {
      allowPing = true;
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [ burke-ed25519 ];
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };

  services.nginx = let
    defaultTLS = { enableACME = true; forceSSL = true; };
    redirect = host: { enableACME = true; addSSL = true; globalRedirect = host; };
    static = root: defaultTLS // { locations."/" = { root = root; }; };
  in {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "10G";

    virtualHosts."pk.tty0.dev" = defaultTLS // {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://localhost:3179";
      };
    };

    virtualHosts."burke.libbey.me" = static "/data/www/burke.libbey.me";
    virtualHosts."libbey.me" = redirect "burke.libbey.me";

    virtualHosts."corinne.rikkelman.com" = static "/data/www/corinne.rikkelman.com";
    virtualHosts."rikkelman.com" = redirect "corinne.rikkelman.com";

    virtualHosts."paulklassen.org" = static "/data/www/paulklassen.org";

    virtualHosts."duckface.ca" = static "/data/www/duckface.ca";

    virtualHosts."tty0.dev" = static "/data/www/tty0.dev" // {
      locations."/nc19".extraConfig = "return 307 https://gist.github.com/burke/694d504be69998dbe4477f80ffa90951;";
    };

  };

  services.perkeepd = {
    enable = true;
    listen = ":3179";
    baseURL = "https://pk.tty0.dev";
    https = false;
    packRelated  = true;
    blobPath = "/data/perkeep/blobs";
    levelDB = "/data/perkeep/index.leveldb";
    identity = secrets.perkeep.identity;
    auth = secrets.perkeep.auth;
    identitySecretRing = secrets.perkeep.identitySecretRing;
    s3 = secrets.perkeep.s3;
    b2 = secrets.perkeep.b2;
  };

  home-manager.users.burke = { 

    programs.git = {
      enable = true;
      userName  = "Burke Libbey";
      userEmail = "burke@libbey.me";
    };

    programs.vim = {
      enable = true;
      plugins = [ "vim-nix" ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=a
        nmap L $
        nmap H ^
        imap kj <esc>
      '';
    };

  };

  users.users.burke = {
    isNormalUser = true;
    home = "/home/burke";
    description = "Burke Libbey";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ burke-ed25519 ];
  };
}
