{
  pkgs,
  home-manager,
  userName,
  ...
}: {
  imports = [
    home-manager.nixosModules.default
  ];

  config = {
    home-manager.users.${userName} = {
      home.packages = with pkgs; [wezterm];

      xdg.configFile."wezterm/wezterm.lua".source = ./dotfiles/wezterm.lua;
    };
  };
}
