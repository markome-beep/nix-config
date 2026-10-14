{ self, inputs, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
      };

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myNeovim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;

          modules = [
            ./_nvf-config.nix
          ];
        }).neovim;
    };
}
