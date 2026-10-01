{
  delib,
  modulesPath,
  lib,
  config,
  pkgs,
  ...
}:
delib.host {
  name = "cifera";

  system = "x86_64-linux";
  home.home.stateVersion = "25.11";

  nixos = {
    myconfig.boot = {
      mode = "uefi";
      generateSecureBootKeys = true;
      enrollSecureBootKeys = true;
    };

    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    system.stateVersion = "25.11";

    boot = {
      initrd = {
        luks.devices."luks" = {
          device = "/dev/disk/by-label/NixOS-LUKS";
          crypttabExtraOpts = [ "tpm2-device=auto" ];
        };

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

      graphics = {
        enable = true;

        extraPackages = [
          (pkgs.intel-compute-runtime.overrideAttrs (old: {
            version = "26.35.39758.10";

            src = pkgs.fetchFromGitHub {
              owner = "intel";
              repo = "compute-runtime";
              tag = "26.35.39758.10";
              hash = "sha256-jPAW4ocbodfRdC8PAvuwd4HFSL6Te/QClDG7XcD3s50=";
            };

            postFixup = (old.postFixup or "") + ''
              for f in "$out/lib"/libze_intel_gpu.so*; do
                [ -f "$f" ] || continue

                patchelf --add-rpath \
                "${lib.getLib pkgs.intel-graphics-compiler}/lib" \
                "$f"
              done
            '';
          }))
        ];
      };
    };

    time.hardwareClockInLocalTime = true;
  };
}
