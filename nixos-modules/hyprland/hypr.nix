{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprpaper
    hypridle
  ];

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
