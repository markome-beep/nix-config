{
  pkgs,
  inputs,
  ...
}: {
  environment.variables = {
    EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    zoxide
    yazi
    tree
    lazygit
    tmux
    unzip

    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;

      modules = [
        ./nvf-config.nix
      ];
    }).neovim
  ];
}
