{pkgs, inputs, ...}: {
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
  
  environment.systemPackages = with pkgs; [
    brightnessctl
    pavucontrol
    wl-clipboard
    wl-clip-persist
    hyprshot
    inputs.quickshell.packages.${pkgs.system}.default
  ];
}
