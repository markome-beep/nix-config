{inputs, pkgs, ...}:
{
  imports = [
    ./nixos/nvf.nix
    ./nixos/hyprland.nix
    ./nixos/main-user.nix
  ]
  programs.zsh.enable = true;
  main-user.enable = true;
  main-user.userName = "pmarko";

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "pmarko" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };
}
