{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rustup
    gcc

    pkg-config
    gobject-introspection
    cargo
    cargo-tauri
    wasm-pack

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
