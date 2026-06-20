{ delib, host, ... }:
delib.module {
  name = "services.syncthing";
  options = delib.singleEnableOption host.guiFeatured;
  home.ifEnabled = {
    services.syncthing = {
      enable = true;
      tray.enable = true;
    };
  };
}
