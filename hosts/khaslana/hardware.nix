{
  delib,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
delib.host {
  name = "khaslana";

  homeManagerSystem = "x86_64-linux";
  home.home.stateVersion = "25.11";

  nixos = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    system.stateVersion = "25.11";

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot = {
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];

        kernelModules = [ ];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];

      loader.grub = {
        gfxmodeEfi = "1920x1080";
        device = "nodev";
      };

      kernelPackages = pkgs.linuxPackages_xanmod_latest;
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NixOS";
        fsType = "xfs";
      };
      "/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
    };

    swapDevices = [ { device = "/swapfile"; } ];

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    networking.networkmanager.wifi.powersave = false;

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };
  };
}
