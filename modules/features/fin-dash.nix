{ inputs, ... }:
{
  flake.nixosModules.fin-dash =
    { pkgs, config, ... }:
    {
      imports = [ inputs.fin-dash.nixosModules.default ];

      # Plaid keys live in a Bitwarden Secrets Manager project, the `bitwarden` provider
      # in fin-dash's secretspec.toml. The secret holds the machine account's token as
      # an env line:
      #   BWS_ACCESS_TOKEN=...
      age.secrets.fin-dash-bws = {
        file = ../../secrets/fin-dash-bws.age;
        owner = "markome";
      };

      programs.fin-dash = {
        enable = true;
        # The launcher hands the keys to SecretSpec, which calls the bws CLI
        package = inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = inputs.fin-dash.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
            secretProvider = "bitwarden";
          };
          runShell = [ "set -a; . ${config.age.secrets.fin-dash-bws.path}; set +a" ];
          prefixVar = [
            [
              "PATH"
              ":"
              "${pkgs.bws}/bin"
            ]
          ];
        };
        # Daily `fin-dash sync` as a systemd user timer, builds net worth history
        sync = {
          enable = true;
          user = "markome";
        };
      };
    };
}
