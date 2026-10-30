{ self, inputs, ... }:
let
  # Upstream's overlays.default builds against our nixpkgs, which it can't do yet (see the
  # mcp-nixos input in flake.nix), so hand out the flake's own package instead
  mcpNixosOverlay = _: prev: {
    mcp-nixos = inputs.mcp-nixos.packages.${prev.stdenv.hostPlatform.system}.default;
  };
in
{
  flake.nixosModules.claude-code =
    { pkgs, ... }:
    {
      # pkgs.mcp-nixos for anything else that wants it
      nixpkgs.overlays = [ mcpNixosOverlay ];

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myClaudeCode
      ];
    };

  perSystem =
    { system, ... }:
    let
      # perSystem's pkgs has neither unfree (claude-code) nor the overlay
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ mcpNixosOverlay ];
      };
    in
    {
      packages.myClaudeCode = inputs.wrapper-modules.wrappers.claude-code.wrap {
        inherit pkgs;

        # Passed with --mcp-config, alongside user/project scoped servers
        mcpConfig = {
          nixos = {
            type = "stdio";
            command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
          };
        };
      };
    };
}
