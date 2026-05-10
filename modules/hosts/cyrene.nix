{ config, ... }:
let
  flakeModules = config.flake.modules;
in
{
  flake.modules.nixos."hosts/cyrene" =
    {
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
          tailscale
          openssh

          arca
        ]
        ++ [
          {
            home-manager.users.arca.imports = with flakeModules.homeManager; [
              base
              shell
              nixvim
              tuiApps
            ];
          }
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "rtsx_usb_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      boot.loader = {
        grub = {
          device = "/dev/disk/by-id/ata-TOSHIBA_MK6475GSX_4226PL3OT";
        };
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/cddb23fa-890b-427c-9123-1ca067db5479";
        fsType = "xfs";
      };

      swapDevices = [
        {
          device = "/dev/disk/by-uuid/191430e2-8ba9-4ca1-ae88-8a5108a023ab";
        }
      ];

      services.logind.settings.Login = {
        HandleLidSwitch = "ignore";
        KillUserProcesses = false;
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
