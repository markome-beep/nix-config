{
  imports = [
    ../../home-manager-modules
  ];
  home.username = "markome";
  home.homeDirectory = "/home/markome";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
