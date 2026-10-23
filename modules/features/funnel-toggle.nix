{ inputs, ... }:
{
  flake.nixosModules.funnel-toggle =
    { config, ... }:
    {
      imports = [ inputs.funnel-toggle.nixosModules.default ];

      # One switch to put Guacamole on the internet via Tailscale Funnel and take it off again:
      # http://dev-one:8090 from your own tailnet devices. LAN devices pair once with the token in
      # /var/lib/funnel-toggle/lan-token: http://<dev-one's LAN IP>:8090/pair?token=<token>
      services.funnel-toggle = {
        enable = true;
        target = "http://127.0.0.1:${toString config.services.tomcat.port}";
        lan.enable = true;
      };
    };
}
