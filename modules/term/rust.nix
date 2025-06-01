{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rustup
    cargo
    gcc
    cargo-tauri
  ];
}
