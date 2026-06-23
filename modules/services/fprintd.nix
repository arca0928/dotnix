{
  delib,
  host,
  ...
}:
delib.module {
  name = "services.fprintd";
  options = delib.singleEnableOption host.fingerprintFeatured;

  nixos.ifEnabled = {
    services.fprintd = {
      enable = true;
    };
  };
}
