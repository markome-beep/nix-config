{ self, inputs, ... }:
{
  flake.nixosConfigurations.dev-one = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.dev-one-configuration
    ];
  };
}
