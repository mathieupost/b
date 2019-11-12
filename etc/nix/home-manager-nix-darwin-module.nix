# This is nearly the default module from home-manager, but the assignments to
# home.username and home.homeDirectory were forcing users.users to manage my
# home directory and I couldn't for the life of me find a way to have it not
# attempt to serialize my whole home directory and fail.
#
# This version of the module just sets the username and homeDirectory directly.
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.home-manager;

  hmModule = types.submodule ({name, ...}: {
    imports = import <home-manager/modules/modules.nix> { inherit lib pkgs; };

    config = {
      submoduleSupport.enable = true;
      submoduleSupport.externalPackageInstall = cfg.useUserPackages;

      home.username = "burke";
      home.homeDirectory = "/Users/burke";

      xdg.enable = true;
      xdg.configHome = "/Users/burke/.config";
      xdg.dataHome = "/Users/burke/.local/share";
      xdg.cacheHome = "/Users/burke/.cache";

    };
  });

in

{
  options = {
    home-manager = {
      useUserPackages = mkEnableOption ''
        installation of user packages through the
        <option>users.users.‹name?›.packages</option> option.
      '';

      users = mkOption {
        type = types.attrsOf hmModule;
        default = {};
        description = ''
          Per-user Home Manager configuration.
        '';
      };
    };
  };

  config = mkIf (cfg.users != {}) {
    warnings =
      flatten (flip mapAttrsToList cfg.users (user: config:
        flip map config.warnings (warning:
        "${user} profile: ${warning}"
        )
      ));

    assertions =
      flatten (flip mapAttrsToList cfg.users (user: config:
        flip map config.assertions (assertion:
          {
            inherit (assertion) assertion;
            message = "${user} profile: ${assertion.message}";
          }
        )
      ));

    users.users = mkIf cfg.useUserPackages (
      mapAttrs (username: usercfg: {
        packages = usercfg.home.packages;
      }) cfg.users
    );

    system.activationScripts.postActivation.text =
      concatStringsSep "\n" (mapAttrsToList (username: usercfg: ''
        echo Activating home-manager configuration for ${username}
        sudo -u ${username} -i ${usercfg.home.activationPackage}/activate
      '') cfg.users);
  };
}
