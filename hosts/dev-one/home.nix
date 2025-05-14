{
  config,
  pkgs,
  ...
}: {
  imports = [
    # (import ../../modules/nixos/hyprland.nix).home-manager
    ../../modules/home-manager/wezterm/wezterm.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pmarko";
  home.homeDirectory = "/home/pmarko";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
