{pkgs, ...}: {
  imports = [
    ./hypr.nix
    ./stylix.nix
    ./greetd.nix
    # ./quickshell.nix
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    wl-clipboard
    wl-clip-persist
  ];
}
