{
  flake.nixosModules.keyring = {
    # Also adds pam_gnome_keyring to the login PAM stack, which greetd includes,
    # so the keyring unlocks with the password typed into tuigreet
    services.gnome.gnome-keyring.enable = true;
    # GUI for viewing and editing stored secrets
    programs.seahorse.enable = true;
  };
}
