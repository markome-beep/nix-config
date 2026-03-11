{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprpaper
    hypridle
    hyprpolkitagent
  ];

  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  programs.dconf.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
