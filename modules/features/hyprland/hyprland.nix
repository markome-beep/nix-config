{ self, inputs, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    {
      programs.hyprland = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprland;
      };
      # The module gives Hyprland cap_sys_nice through a security wrapper around the
      # package's binary, but ours is a script wrapper and those can't carry
      # capabilities. Point it at the real binary instead, start-hyprland finds it
      # first on PATH and it inherits the env start-hyprland's wrapper already set
      security.wrappers.Hyprland.source = lib.mkForce (lib.getExe' pkgs.hyprland "Hyprland");
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
      packages.myHyprland = inputs.wrapper-modules.wrappers.hyprland.wrap (
        { config, ... }:
        {
          inherit pkgs;

          # The module wraps this in a generated config (plugin and lua package
          # loading) and checks it with `Hyprland --verify-config` at build time
          configFile = ./hyprland.lua;

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

          # start-hyprland is what greetd runs, it has to carry the same environment.
          # It doesn't take --config, and the Hyprland it launches is the capability
          # wrapper around the unwrapped binary (see security.wrappers above), so
          # hand it the config through the environment instead of the mirrored flag
          wrapperVariants.start-hyprland = {
            flags = { };
            env.HYPRLAND_CONFIG = config."hyprland.lua".path;
          };
          aliases = [ "hyprland" ];
          filesToPatch = [ "share/wayland-sessions/*.desktop" ];
        }
      );
    };
}
