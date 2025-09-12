# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixos-modules
  ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "markome" = import ./home.nix;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

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
    extraGroups = ["networkmanager" "wheel"];
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
