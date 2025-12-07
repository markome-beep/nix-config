{pkgs, ...}: {
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
  
  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    wl-clipboard
    wl-clip-persist
    quickshell
    hyprshot
    # slurp
    # grim
    # libnotify
    # jq
  ];
}
