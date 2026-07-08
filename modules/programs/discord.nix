{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.discord";
  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.packages = [
      (pkgs.discord.override {
        withEquicord = true;
        withOpenASAR = true;
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --force-device-scale-factor=1.0";
      })
    ];
  };
}
