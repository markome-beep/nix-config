{ inputs, ... }:
{
  flake.nixosModules.funnel-toggle =
    { config, ... }:
    {
      imports = [ inputs.funnel-toggle.nixosModules.default ];

      # One switch for remote access, from tailnet devices only:
      # https://dev-one.tail22d0de.ts.net:8443
      # On starts Guacamole (guacd, Tomcat, wayvnc) and then Funnels it to the internet; off
      # turns Funnel off and stops them all. Everything starts off after a reboot
      services.funnel-toggle = {
        enable = true;
        target = "http://127.0.0.1:${toString config.services.tomcat.port}";
        services = [
          "guacamole-server"
          "tomcat"
        ];
        userServices.markome = [ "wayvnc" ];
      };
    };
}
