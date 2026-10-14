{ inputs, ... }:
{
  flake.nixosModules.blip = {
    imports = [ inputs.blip.nixosModules.default ];

    programs.blip.enable = true;
  };
}
