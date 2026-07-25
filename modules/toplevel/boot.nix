{
  delib,
  host,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "boot";

  options = {
    boot = with delib; {
      enable = boolOption true;

      loader = enumOption [ "grub" "systemd-boot" ] (
        if host.securebootFeatured then "systemd-boot" else "grub"
      );

      mode = enumOption [
        "uefi"
        "bios"
      ] "uefi";

      grubDevice = strOption "nodev";
      generateSecureBootKeys = boolOption false;
      enrollSecureBootKeys = boolOption false;
    };
  };

  nixos.always.imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  nixos.ifEnabled =
    { cfg, ... }:
    let
      isEfi = if cfg.mode == "uefi" then true else false;
    in
    {
      boot = {
        loader = {
          efi.canTouchEfiVariables = isEfi;
          grub = lib.mkIf (cfg.loader == "grub") {
            enable = true;
            efiSupport = isEfi;
            devices = [ cfg.grubDevice ];
          };
        };

        lanzaboote = lib.mkIf (cfg.loader == "systemd-boot") {
          enable = true;
          configurationLimit = 5;
          pkiBundle = "/var/lib/sbctl";

          autoGenerateKeys.enable = cfg.generateSecureBootKeys;
          autoEnrollKeys = {
            enable = cfg.enrollSecureBootKeys;
            includeMicrosoftKeys = true;
            autoReboot = false;
          };

          measuredBoot = {
            enable = true;
            pcrs = [
              0
              2
              4
              7
            ];
          };
        };
      };
    };
}
