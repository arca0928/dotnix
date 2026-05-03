{ config, ... }:
let
  flakeModules = config.flake.modules;
in
{
  flake.modules.nixos."hosts/khaslana" =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports =
        with flakeModules.nixos;
        [
          base
          tailscale
          openssh
          gui

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
        ];

      boot = {
        initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        initrd.kernelModules = [ ];

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

      swapDevices = [
        {
          device = "/swapfile";
        }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      system.stateVersion = "25.11";

      networking.networkmanager.wifi.powersave = false;

      # for nvidia gpu
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics.enable = true;
      hardware.nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        powerManagement.enable = true;
        open = false;
      };
    };

  flake.modules.homeManager.base = {
    home.stateVersion = "25.11";
  };
}
