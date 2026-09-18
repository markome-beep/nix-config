{ inputs, ... }: {

  flake.nixosModules.niri =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = self'.packages.myNiri;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {

      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = {
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          layout = {
            gaps = 4;
            focus-ring = {
              off = [ ];
            };
            border = {
              width = 2;
              active-gradient = _: {
                props = {
                  from = "#33ccffee";
                  to = "#00ff99ee";
                  angle = 45;
                  relative-to = "workspace-view";
                };
              };
              inactive-color = "#595959aa";
            };
          };

          window-rule = {
            geometry-corner-radius = 12;
            clip-to-geometry = true;
          };

          binds =
            lib.attrsets.mergeAttrsList (
              map (i: {
                "Mod+${toString i}".focus-workspace = i;
                "Mod+Shift+${toString i}".move-column-to-workspace = i;
              }) (lib.range 1 4)

            )
            // {
              "Mod+Q".close-window = [ ];
              "Mod+T".spawn-sh = lib.getExe pkgs.wezterm;
            };

          input = {
            focus-follows-mouse = [ ];
          };
        };
      };
    };
}
