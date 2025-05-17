{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.main-user;
in {
  options.main-user = {
    enable =
      lib.mkEnableOption "enable user module";

    userName = lib.mkOption {
      default = "mainuser";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      initialPassword = "nixos";
      description = "Main User";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };

    home-manager = {
      backupFileExtension = "backup";

      users.${cfg.userName} = {
        home.username = cfg.userName;
        home.homeDirectory = "/home/${cfg.userName}";

        home.sessionVariables = {
          EDITOR = "nvim";
        };

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;

        home.stateVersion = "24.11";
      };
    };
  };
}
