{ self, inputs, ... }:
{
  flake.nixosModules.hyprpaper =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprpaper
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myHyprpaper = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.hyprpaper;

        flags."--config" = pkgs.writeText "hyprpaper.conf" ''
          preload=${./nix-dark.png}

          wallpaper {
            monitor=
            path=${./nix-dark.png}
          }
          splash=false
        '';
      };
    };
}
