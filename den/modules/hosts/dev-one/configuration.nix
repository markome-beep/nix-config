{ self, inputs, ... }:
{
  flake.nixosModules.dev-one-configuration = { pkgs, lib, config, ... }: {
    imports = [
      self.nixosModules.dev-one-hardware
      self.nixosModules.niri
      self.nixosModules.cli-apps
    ];

    age.secrets.github-token.file = ../../../secrets/github-token.age;
    age.identityPaths = [ "/home/markome/.ssh/id_ed25519" ];

    nix.settings = {
      access-tokens = config.age.secrets.github-token.path;
      extra-platforms = [ "aarch64-linux" ];
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };

    # home-manager = {
    #   extraSpecialArgs = { inherit inputs; };
    #   backupFileExtension = "backup";
    #   users = {
    #     "markome" = import ./home.nix;
    #   };
    # };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "dev-one";
    networking.networkmanager.enable = true;
    services.openssh = {
      enable = true;
    };

    services.udisks2.enable = true;
    services.gvfs.enable = true;

    time.timeZone = "America/Chicago";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    services.xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:swapescape";
      };
    };

    users.users.markome = {
      isNormalUser = true;
      description = "Pirro Marko";
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "docker"
      ];
    };

    virtualisation.docker = {
      enable = true;
    };

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "25.05";
  };
}
