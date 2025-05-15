{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./nvf.nix
    ./hyprland.nix
    ./main-user.nix
    ./wezterm.nix
  ];
}
