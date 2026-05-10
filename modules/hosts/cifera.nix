{ config, ... }:
let
  flakeModules = config.flake.modules;
in
{
  flake.modules.nixos."hosts/cifera" =
    {
      inputs,
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports =
        with flakeModules.nixos;
        [
          base
          openssh
          gui
          fprintd

          arca
        ]
        ++ [
          {
            home-manager.users.arca.imports = with flakeModules.homeManager; [
              base
              terminal
              zenBrowser
              nixvim
              guiApps
              shell
              tuiApps
              dots
            ];
          }
          (modulesPath + "/installer/scan/not-detected.nix")
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
      boot.initrd.luks.devices."luks".device = "/dev/disk/by-label/NixOS-LUKS";

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      boot.loader.grub.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      fileSystems."/" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [ "subvol=home" ];
      };

      fileSystems."/nix" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [
          "subvol=nix"
          "noatime"
        ];
      };

      fileSystems."/swap" = {
        device = "/dev/disk/by-label/NixOS-ROOT";
        fsType = "btrfs";
        options = [
          "subvol=swap"
          "noatime"
        ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.npu.enable = true;
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      system.stateVersion = "25.11";

      time.hardwareClockInLocalTime = true;

      # enable bluetooth
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    };
}
