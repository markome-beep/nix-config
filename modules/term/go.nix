{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    go
    gnumake
    wails
  ];
}
