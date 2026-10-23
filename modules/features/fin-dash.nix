{ inputs, ... }:
{
  flake.nixosModules.fin-dash = {
    imports = [ inputs.fin-dash.nixosModules.default ];

    # Plaid keys come from SecretSpec via gnome-keyring (see the keyring feature)
    programs.fin-dash = {
      enable = true;
      # Daily `fin-dash sync` as a systemd user timer, builds net worth history
      sync = {
        enable = true;
        user = "markome";
      };
    };
  };
}
