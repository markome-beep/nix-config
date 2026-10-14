{ self, inputs, ... }:
{
  flake.nixosModules.swaync =
    { pkgs, lib, ... }:
    let
      inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) mySwaync;
    in
    {
      environment.systemPackages = [ mySwaync ];
      services.dbus.packages = [ mySwaync ];

      systemd.user.services.swaync = {
        description = "Swaync notification daemon";
        documentation = [ "https://github.com/ErikReider/SwayNotificationCenter" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
        serviceConfig = {
          Type = "dbus";
          BusName = "org.freedesktop.Notifications";
          ExecStart = lib.getExe mySwaync;
          Restart = "on-failure";
        };
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.mySwaync = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.swaynotificationcenter;

        flags."--style" = ./tokyo-night-dark.css;

        filesToPatch = [ "share/dbus-1/services/*.service" ];
      };
    };
}
