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
  } @ inputs: let
    sys = nixpkgs.lib.nixosSystem;
    userName = "pmarko";
  in {
    nixosConfigurations = {
      dev-one = sys {
        specialArgs = {
          inherit home-manager;
          inherit userName;
        };
        modules = [
          ./hosts/dev-one/configuration.nix
          ./modules
          inputs.nvf.nixosModules.default
        ];
      };
    };
  };
}
