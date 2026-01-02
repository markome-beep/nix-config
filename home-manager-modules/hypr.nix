{pkgs, ...}: {

  xdg.configFile."hypr/background".source = ../assests/nix-dark.png;
  services.hyprpaper = {
    enable = true;

    settings = {
      preload = ["~/.config/hypr/background"];

      wallpaper = [
        ",~/.config/hypr/background"
      ];
    };
  };

  services.hypridle.enable = true;
  programs.rofi.enable = true;
  services.swaync.enable = true;
  # home.pointerCursor = {
  #   hyprcursor.enable = true;
  #
  #   package = pkgs.bibata-cursors;
  #   name = "BreezeX-Dark";
  #   # size = 24; # Adjust size as needed
  #   # gtk.enable = true;
  #   # x11.enable = true;
  # };

  # home.file.".icons/BreezeX_Cursor" = {
  #   source = ../assests/cursor;
  #   recursive = true;
  # };
}
