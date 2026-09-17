{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "services.syncthing";
  options = delib.singleEnableOption host.guiFeatured;
  home.ifEnabled = {
    services.syncthing = {
      enable = true;
      tray.enable = pkgs.stdenv.hostPlatform.isLinux;
    };
  };
}
