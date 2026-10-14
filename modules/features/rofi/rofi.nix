{ self, inputs, ... }:
{
  flake.nixosModules.rofi =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myRofi
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myRofi = inputs.wrapper-modules.wrappers.rofi.wrap {
        inherit pkgs;

        settings.font = "DejaVu Sans Mono 10";
        theme = "${./tokyo-night-dark.rasi}";
      };
    };
}
