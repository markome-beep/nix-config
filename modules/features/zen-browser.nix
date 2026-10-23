{ self, ... }:
{
  flake.nixosModules.zen-browser =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myZen
      ];
    };

  perSystem =
    { pkgs, inputs', ... }:
    let
      # Policies have to go on the unwrapped package: the wrapper's binary is a
      # symlink into it, so Zen looks for distribution/policies.json there and
      # never reads the one wrapFirefox writes
      unwrapped = inputs'.zen-browser.packages.beta-unwrapped.override {
        extraPolicies =
          let
            mkExtensionSettings = builtins.mapAttrs (
              _: pluginId: {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
                installation_mode = "force_installed";
              }
            );
          in
          {
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            # Bitwarden handles logins
            OfferToSaveLogins = false;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };

            ExtensionSettings = mkExtensionSettings {
              "uBlock0@raymondhill.net" = "ublock-origin";
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
            };
          };
      };
    in
    {
      # Same as the flake's wrap-zen.nix: wrapFirefox picks ffmpeg by version, so
      # it gets the Gecko version and the real one is restored afterwards
      packages.myZen = pkgs.wrapFirefox (unwrapped // { version = unwrapped.firefoxVersion or "9999"; }) {
        inherit (unwrapped) version;
        icon = "zen-browser";
      };
    };
}
