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
      ] (if builtins.pathExists /sys/firmware/efi/efivars then "uefi" else "bios");

      grubDevice = strOption "nodev";
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

          autoGenerateKeys.enable = true;
          autoEnrollKeys = {
            enable = true;
            includeMicrosoftKeys = true;
            autoReboot = true;
          };

          measuredBoot = {
            enable = true;
            pcrs = [
              0
              4
              7
            ];
          };
        };
      };
    };
}
