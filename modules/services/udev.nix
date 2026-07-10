{ delib, pkgs, ... }:
delib.module {
  name = "services.udev";

  nixos.always = {
    services.udev = {

      packages = with pkgs; [
        qmk
        qmk-udev-rules
        qmk_hid
        via
        vial
      ];

    };
  };
}
