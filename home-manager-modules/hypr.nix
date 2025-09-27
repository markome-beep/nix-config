{pkgs, ...}: {
  services.hyprpaper.enable = true;
  services.hypridle.enable = true;
  programs.rofi.enable = true;
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
