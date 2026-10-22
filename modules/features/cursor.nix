{ self, ... }:
{
  flake.nixosModules.cursor =
    { pkgs, lib, ... }:
    let
      cursor = self.packages.${pkgs.stdenv.hostPlatform.system}.breezex-cursor;
      # Single source of truth: Hyprland, XWayland, GTK and Steam all read these
      theme = "BreezeX-Black";
      size = 40;
    in
    {
      environment.systemPackages = [ cursor ];

      environment.sessionVariables = {
        XCURSOR_THEME = theme;
        XCURSOR_SIZE = toString size;
      };

      # GTK apps read the cursor from dconf rather than the environment
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            cursor-theme = theme;
            cursor-size = lib.gvariant.mkInt32 size;
          };
        }
      ];

      # icons/default/index.theme, for X apps that ignore XCURSOR_THEME
      xdg.icons.fallbackCursorThemes = [ theme ];

      # Steam's UI runs in a container that can't see /run/current-system, only
      # its own FHS /usr/share/icons, so the theme has to be in there too. Its CEF
      # ignores XCURSOR_THEME and only loads the "default" theme, so that goes too
      programs.steam.extraPackages = [
        cursor
        (pkgs.writeTextDir "share/icons/default/index.theme" ''
          [Icon Theme]
          Inherits=${theme}
        '')
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.breezex-cursor = pkgs.stdenv.mkDerivation {
        pname = "breezex-cursor";
        version = "2.0.1";

        src = pkgs.fetchzip {
          url = "https://github.com/ful1e5/BreezeX_Cursor/releases/download/v2.0.1/BreezeX-Black.tar.xz";
          hash = "sha256-uRmCyFVpVN+47r9HXErxZQjheGdLPcGJTwc+mDvF9Os=";
        };

        installPhase = ''
          # The theme folder needs to match the name the cursor is selected by
          mkdir -p $out/share/icons/BreezeX-Black
          cp -r * $out/share/icons/BreezeX-Black/
        '';
      };
    };
}
