{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.vial";

  options = delib.singleEnableOption (host.guiFeatured && pkgs.stdenv.hostPlatform.isLinux);

  home.ifEnabled.home.packages = with pkgs; [ vial ];
}
