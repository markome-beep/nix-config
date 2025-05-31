{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    go
    wails
    webkitgtk_4_1
  ];
}
