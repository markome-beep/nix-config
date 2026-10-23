{ self, inputs, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprland;
      };
      programs.dconf.enable = true;

      # graphical-session.target can't be started by hand, so Hyprland starts this
      # target on launch (see hyprland.lua) and it pulls graphical-session.target up
      # with it. Portals require it, without it there's no screen sharing or file drag and drop
      systemd.user.targets.hyprland-session = {
        description = "Hyprland compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
      };
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      environment.systemPackages = with pkgs; [
        hypridle
        hyprpolkitagent
        hyprshot
        brightnessctl
        pavucontrol
        wl-clipboard
        wl-clip-persist
        inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

  perSystem =
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    {
      packages.myHyprland = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.hyprland;

        env.HYPRLAND_CONFIG = ./hyprland.lua;

        # Everything hyprland.lua launches by name, put first on PATH so
        # nothing else on the system can shadow the wrapped versions
        runtimePkgs =
          map
            (data: {
              inherit data;
              prefix = true;
            })
            [
              self'.packages.myWezterm
              self'.packages.myZen
              self'.packages.myRofi
              self'.packages.myHyprlock
              self'.packages.myHyprpaper
              inputs'.quickshell.packages.default
              pkgs.hypridle
              pkgs.hyprshot
              pkgs.brightnessctl
            ];

        # start-hyprland is what greetd runs, it has to carry the same environment
        wrapperVariants.start-hyprland = { };
        aliases = [ "hyprland" ];
        filesToPatch = [ "share/wayland-sessions/*.desktop" ];
        passthru.providedSessions = pkgs.hyprland.passthru.providedSessions;
      };
    };
}
