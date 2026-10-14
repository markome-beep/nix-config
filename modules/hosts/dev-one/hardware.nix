{
  flake.nixosModules.dev-one-hardware = {
    # Output of nixos-generate-config, left untouched so it can be regenerated
    imports = [ ./_hardware-configuration.nix ];

    boot.initrd.availableKernelModules = [
      "uas"
      "usb_storage"
      "sd_mod"
    ];

    boot.kernelModules = [
      "usbserial"
      "cp210x"
    ];
  };
}
