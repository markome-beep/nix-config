{ self, ... }:
{
  flake.nixosModules.cursor =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.breezex-cursor
      ];

      environment.sessionVariables = {
        XCURSOR_THEME = "BreezeX-Black";
        XCURSOR_SIZE = "48";
      };

      # GTK apps read the cursor from dconf rather than the environment
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            cursor-theme = "BreezeX-Black";
            cursor-size = lib.gvariant.mkInt32 48;
          };
        }
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
