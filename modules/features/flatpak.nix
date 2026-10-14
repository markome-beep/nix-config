{ inputs, ... }:
{
  flake.nixosModules.flatpak = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

    services.flatpak = {
      enable = true;
      packages = [
        "com.orcaslicer.OrcaSlicer"
        "com.bambulab.BambuStudio"
      ];
    };
  };
}
