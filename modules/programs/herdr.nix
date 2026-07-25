{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.herdr";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    herdr
  ];
}
