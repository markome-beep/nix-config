{ pkgs, ... }:
let
  # 1. Create a custom package to download the cursor
  breezex-cursor = pkgs.stdenv.mkDerivation {
    pname = "breezex-cursor";
    version = "2.0.1"; # Latest version on their GitHub

    src = pkgs.fetchzip {
      url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Black.tar.xz";

      # NOTE: On your first build, Nix will complain about a hash mismatch.
      # Copy the correct "got: sha256-..." hash from the error message and replace this line!
      hash = "sha256-uRmCyFVpVN+47r9HXErxZQjheGdLPcGJTwc+mDvF9Os=";
    };

    installPhase = ''
      # The theme folder needs to match exactly what you set in home.pointerCursor.name
      mkdir -p $out/share/icons/BreezeX-Black
      cp -r * $out/share/icons/BreezeX-Black/
    '';
  };
in
{
  xdg.configFile."hypr/background".source = ../assests/nix-dark.png;
  services.hyprpaper = {
    enable = true;

    settings = {
      preload = [ "~/.config/hypr/background" ];
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "~/.config/hypr/background";
        }
      ];
    };
  };

  services.hypridle.enable = true;
  programs.rofi.enable = true;
  services.swaync.enable = true;
  # home.nix
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "BreezeX-Black"; # The name of the cursor theme
    package = breezex-cursor; # The package providing the theme
    size = 48;
  };

  # Make sure GTK is enabled globally in Home Manager so the cursor applies to GTK apps
  gtk.enable = true;

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
