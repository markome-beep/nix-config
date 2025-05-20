{
  pkgs,
  home-manager,
  config,
  ...
}: let
  userName = config.main-user.userName;
in {
  imports = [
    home-manager.nixosModules.default
  ];

  config = {
    home-manager.users.${userName} = {
      home.packages = with pkgs; [wezterm];

      xdg.configFile."wezterm/wezterm.lua".source = ./dotfiles/wezterm.lua;
      xdg.home.".zshrc".source = ./dotfiles/.zshrc;
    };
  };
}
