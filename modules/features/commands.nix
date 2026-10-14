{ self, ... }:
{
  flake.nixosModules.commands =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myCommands
      ];
    };

  perSystem =
    { pkgs, lib, ... }:
    let
      # Each entry becomes a command of that name
      commands = {
        # Extra arguments are passed on to nixos-rebuild, e.g. `rebuild --show-trace`
        rebuild = ''
          flake="''${NIXOS_FLAKE:-$HOME/nixos-config/dendritic}"

          exec sudo nixos-rebuild switch --flake "$flake" "$@"
        '';
      };
    in
    {
      packages.myCommands = pkgs.symlinkJoin {
        name = "my-commands";
        paths = lib.mapAttrsToList (name: text: pkgs.writeShellApplication { inherit name text; }) commands;
      };
    };
}
