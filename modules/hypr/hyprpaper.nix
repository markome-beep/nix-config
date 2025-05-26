{
  config,
  home-manager,
  ...
}: let
  userName = config.main-user.userName;
in {
  imports = [
    home-manager.nixosModules.default
  ];

  config = {
    home-manager.users.${userName} = {
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = ["/home/${userName}/Downloads/bg.jpeg"];
          wallpaper = ",/home/${userName}/Downloads/bg.jpeg";
        };
      };
    };
  };
}
