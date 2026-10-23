{
  flake.nixosModules.tailscale = {
    # Reach this machine from anywhere on the tailnet, e.g. Guacamole at
    # http://dev-one:8080/guacamole/ (WireGuard encrypts it, so plain HTTP is fine there).
    # One-time login: `sudo tailscale up`
    services.tailscale = {
      enable = true;
      # Opens the WireGuard UDP port so peers connect directly instead of via DERP relays
      openFirewall = true;
    };
  };
}
