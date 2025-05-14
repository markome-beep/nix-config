{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  config = {
    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      backupFileExtension = "backup";

      users.pmarko = {
        home.packages = with pkgs; [wezterm];

        xdg.configFile."wezterm/wezterm.lua".source = ./dotfiles/wezterm.lua;
      };
    };
  };
}
