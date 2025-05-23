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
    ./go
    ./rust
  ];

  config = {
    environment.defaultPackages = with pkgs; [
      zoxide
      wezterm
      lazygit
    ];

    home-manager.users.${userName} = {
      xdg.configFile."wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
      home.file.".zshrc".source = ../dotfiles/.zshrc;
    };
  };
}
