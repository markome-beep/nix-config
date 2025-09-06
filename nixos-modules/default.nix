{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hyprland
  ];

  environment.systemPackages = with pkgs; [
    microsoft-edge
    inputs.zen-browser.packages."x86_64-linux".default
    zoxide

    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;

      modules = [
        ./nvf-config.nix
      ];
    }).neovim
  ];
}
