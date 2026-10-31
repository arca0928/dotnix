{
  delib,
  host,
  mypkgs,
  ...
}:
delib.module {
  name = "programs.dsh";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.home.packages = [
    mypkgs.dsh
  ];
}
