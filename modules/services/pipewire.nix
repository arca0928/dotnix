{ delib, host, ... }:
delib.module {
  name = "services.pipewire";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
  };
}
