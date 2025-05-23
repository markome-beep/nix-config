{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./term/nvf.nix
    ./term/wezterm.nix
    ./hypr/hyprland.nix
    ./main-user.nix
  ];
}
