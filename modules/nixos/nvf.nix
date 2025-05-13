{inputs, pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "tokyonight";
        };

	languages.nix.enable = true;
      }
    }
  }
}
