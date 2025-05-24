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
    ./go.nix
    ./rust.nix
  ];

  config = {
    environment.defaultPackages = with pkgs; [
      zoxide
      wezterm
      lazygit
      starship
      btop
      fastfetch
      zsh-autosuggestions
    ];

    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
    };

    home-manager.users.${userName} = {
      xdg.configFile."wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
      home.file.".zshrc".source = ../dotfiles/.zshrc;
    };
  };
}
