{ inputs, ... }:
{
  flake.nixosModules.stylix =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      };

      # Stylix only sets the dark preference through home-manager, so set it in
      # dconf directly. The GTK portal hands color-scheme to apps (libadwaita,
      # Electron, Firefox/Zen) as their "system theme", and GTK3 apps that ignore
      # it fall back to gtk-theme
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
          };
        }
      ];
    };
}
