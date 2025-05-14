{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./nixos/nvf.nix
    ./nixos/hyprland.nix
    ./nixos/main-user.nix
    ./wezterm.nix
  ];
}
