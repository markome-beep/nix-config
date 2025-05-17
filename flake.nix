{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      dev-one = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit home-manager;};
        # null = builtins.trace nixpkgs;
        modules = [
          ./hosts/dev-one/configuration.nix
          ./modules
          home-manager.nixosModules.default
          inputs.nvf.nixosModules.default
        ];
      };
    };
  };
}
