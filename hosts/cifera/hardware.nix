{
  delib,
  modulesPath,
  lib,
  config,
  ...
}:
delib.host {
  name = "cifera";

  system = "x86_64-linux";
  home.home.stateVersion = "25.11";

  nixos = {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    system.stateVersion = "25.11";

    boot = {
      initrd = {
        luks.devices."luks".device = "/dev/disk/by-label/NixOS-LUKS";

        availableKernelModules = [
          "xhci_pci"
          "thunderbolt"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };

      "/home" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [ "subvol=home" ];
      };

      "/nix" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [
          "subvol=nix"
          "noatime"
        ];
      };

      "/swap" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [
          "subvol=swap"
          "noatime"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    hardware = {
      cpu.intel = {
        npu.enable = true;
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };

    time.hardwareClockInLocalTime = true;
  };
}
