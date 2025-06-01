{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_edge.url = "github:nixos/nixpkgs/nixos-24.11";

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
          inherit inputs;
          pkgs_edge = import inputs.nixpkgs_edge {
            system = "x86_64-linux";
            config.allowUnfree = true;
            inherit (nixpkgs) lib;
          };
        };
        modules = [
          ./hosts/dev-one/configuration.nix
          ./modules
          inputs.nvf.nixosModules.default
          home-manager.nixosModules.default
        ];
      };
    };
  };
}
