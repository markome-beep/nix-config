{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    package = null;
    portalPackage = null;

    settings = {
      monitor = ",prefered,auto,1";

      "$terminal" = "wezterm";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      exec-once = [
        "$terminal"
        "waybar & hyprpaper & microsoft-edge --ozone-platform=wayland '$@'"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      input = {
        touchpad = {
          natural_scroll = true;
        };
      };

      "$mod" = "SUPER";

      bind =
        [
          # Main Binds
          "$mod, q, killactive,"
          "$mod, t, exec, $terminal"
          "$mod, m, exit,"
          "$mod, f, exec, $fileManager"
          "$mod, b, exec, microsoft-edge --ozone-platform=wayland '$@'"

          # Movement
          "$mod, l, movefocus, r"
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"

          # Workspaces
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };
}
