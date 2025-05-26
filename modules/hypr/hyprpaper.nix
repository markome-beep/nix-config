{config, ...}: let
  userName = config.main-user.userName;
in {
  home-manager.users.${userName} = {
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = ["/home/${userName}/Downloads/bg.jpeg"];
        wallpaper = ",/home/${userName}/Downloads/bg.jpeg";
      };
    };
  };
}
