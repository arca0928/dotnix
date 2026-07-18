{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.herdr";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    herdr
  ];
}
