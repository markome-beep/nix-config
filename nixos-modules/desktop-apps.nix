{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages."x86_64-linux".default
    obs-studio
    vlc
    discord
    steam
  ];

  xdg.mime.defaultApplications = {
    "media/mkv" = [ "vlc.desktop" ];
  };
}
