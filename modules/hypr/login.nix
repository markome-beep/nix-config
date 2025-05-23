{
  pkgs,
  config,
  ...
}: let
  userName = config.main-user.userName;
in {
  services = {
    # Login
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = userName;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
}
