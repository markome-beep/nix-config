{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
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
