{config, ...}: let
  userName = config.main-user.userName;
in {
  programs = {
    waybar.enable = true;
  };

  home-manager.users.${userName} = {
    xdg.configFile."waybar/config".source = ../dotfiles/waybar.jsonc;
  };
}
