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
    let
      # Desktop entries for terminal programs (and rofi itself) that aren't tagged
      # ConsoleOnly. An entry with the same id earlier in XDG_DATA_DIRS wins, so
      # these NoDisplay copies hide the real ones from drun
      hiddenApps = pkgs.runCommand "rofi-hidden-apps" { } ''
        mkdir -p $out/share/applications
        for id in nvim xterm rofi rofi-theme-selector; do
          printf '[Desktop Entry]\nType=Application\nName=%s\nNoDisplay=true\n' "$id" \
            > "$out/share/applications/$id.desktop"
        done
      '';
    in
    {
      packages.myRofi = inputs.wrapper-modules.wrappers.rofi.wrap {
        inherit pkgs;

        settings = {
          show-icons = true;
          icon-theme = "Papirus-Dark";

          display-combi = "❯";
          combi-hide-mode-prefix = true;
          drun-display-format = "{name}";
          window-format = "{t}";

          # Matching on exec and categories pulls in apps like "google-chrome-stable" for "bl"
          drun-match-fields = "name,generic,keywords";

          # Terminal-only programs (btop, yazi, ...) don't belong in the launcher
          drun-exclude-categories = "ConsoleOnly";
        };
        theme = "${./theme.rasi}";

        prefixVar = [
          [
            "XDG_DATA_DIRS"
            ":"
            "${hiddenApps}/share"
          ]
        ];

        # Ship the icon theme with rofi instead of installing it system wide
        suffixVar = [
          [
            "XDG_DATA_DIRS"
            ":"
            "${pkgs.papirus-icon-theme}/share"
          ]
        ];
      };
    };
}
