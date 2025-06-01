{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rustup
    cargo
    gcc
    cargo-tauri
    pkg-config
    gobject-introspection
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    librsvg
    libsoup_3
    pango
    webkitgtk_4_1
    openssl
  ];
}
