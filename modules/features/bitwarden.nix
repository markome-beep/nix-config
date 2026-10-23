{
  flake.nixosModules.bitwarden =
    { pkgs, ... }:
    {
      # `bw` is the CLI for scripting, the Zen extension is in zen-browser.nix.
      # `bws` is the Secrets Manager CLI, where app secrets live (see fin-dash.nix)
      environment.systemPackages = with pkgs; [
        bitwarden-desktop
        bitwarden-cli
        bws
      ];
    };
}
