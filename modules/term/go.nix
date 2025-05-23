{pkgs, ...}: {
  environment.defaultPackages = with pkgs; [
    go
  ];
}
