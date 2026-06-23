{ delib, host, ... }:
delib.module {
  name = "services.flatpak";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    services.flatpak = {
      enable = true;
    };
  };
}
