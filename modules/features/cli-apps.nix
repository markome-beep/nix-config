{
  flake.nixosModules.cli-apps =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        yazi
        tree
        unzip
        ripgrep
        fzf
        devenv
      ];
    };
}
