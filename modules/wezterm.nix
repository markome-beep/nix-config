{
  pkgs,
  home-manager,
  ...
}: {
  imports = [
    home-manager.nixosModules.default
  ];

  config = {
    home-manager.users.pmarko = {
      home.packages = with pkgs; [wezterm];

      xdg.configFile."wezterm/wezterm.lua".source = ./dotfiles/wezterm.lua;
    };
  };
}
