{
  pkgs,
  config,
  ...
}: let
  userName = config.main-user.userName;
in {
  imports = [
    ./go.nix
    ./rust.nix
    ./lua.nix
    ./node.nix
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
      autosuggestions.enable = true;
    };

    home-manager.users.${userName} = {
      xdg.configFile."wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
      home.file.".zshrc".source = ../dotfiles/.zshrc;
    };
  };
}
