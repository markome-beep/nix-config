{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    vlc
    steam
    discord
    plex-desktop
    google-chrome
    nautilus
    blender

    droidcam
  ];

  xdg.mime.defaultApplications = {
    "media/mkv" = [ "vlc.desktop" ];
  };
  programs.steam.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };

  hardware.amdgpu.opencl.enable = true;
  # Note: In newer NixOS versions, hardware.opengl has been renamed to hardware.graphics
  hardware.graphics.enable = true;
  # Enable the AMDGPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  users.users.markome.extraGroups = [ "video" ];
}
