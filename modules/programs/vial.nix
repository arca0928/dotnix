{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.vial";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.home.packages = with pkgs; [ vial ];
}
