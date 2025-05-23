{pkgs, ...}: {
  environment.defaultPackages = with pkgs; [
    rustup
  ];
}
