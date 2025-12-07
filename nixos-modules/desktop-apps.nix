{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages."x86_64-linux".default
    obs-studio
    vlc
    steam
    discord
    plex-desktop
    google-chrome
    nautilus
    rpi-imager
  ];

  xdg.mime.defaultApplications = {
    "media/mkv" = [ "vlc.desktop" ];
  };
  programs.steam.enable = true;
}
