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

        # Everything hyprland.lua launches by name
        runtimePkgs = [
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
