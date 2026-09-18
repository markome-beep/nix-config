{ inputs, ... }: {
  flake.nixosModules.cli-apps =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      environment.variables = {
        EDITOR = "nvim";
      };

      environment.systemPackages = with pkgs; [
        zoxide
        tree
        lazygit
        tmux
        unzip
        ripgrep

        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;

          modules = [
            ./nvf-config.nix
          ];
        }).neovim
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
    inputs,
      self',
      ...
    }:
    {

      packages.myNVF = inputs.wrapper-modules.wrappers.niri.wrap { };

    };
}
