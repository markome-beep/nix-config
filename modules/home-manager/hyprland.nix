{pkgs, lib, ...}: {
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    settings = {
      monitor = ",prefered,auto,1";
      input = {
        touchpad = {
	  natural_scroll = true;
	};
      };
      "$mod" = "SUPER";
      bind = [
        "$mod, b, exec, microsoft-edge --ozone-platform=wayland '$@'"
	"$mod, t, exec, kitty"
	"$mod_SHIFT, t, exec, wezterm"
      ];
    };
  };
}
