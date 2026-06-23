{ delib, host, ... }:
delib.module {
  name = "bluetooth";

  options = delib.singleEnableOption host.bluetoothFeatured;

  nixos.ifEnabled = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
