{
  pkgs,
  config,
  ...
}: let
  userName = config.main-user.userName;
in {
  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          user = userName;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        };
      };
    };
  };
}
