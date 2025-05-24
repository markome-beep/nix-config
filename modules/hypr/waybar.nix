{
  pkgs,
  config,
  home-manager,
  ...
}: let
  userName = config.main-user.userName;
in {
  imports = [
    home-manager.nixosModules.default
  ];

  config = {
    programs = {
      waybar.enable = true;
    };

    home-manager.users.${userName} = {
      xdg.configFile."waybar/config".source = ../dotfiles/waybar.jsonc;
    };
  };
}
