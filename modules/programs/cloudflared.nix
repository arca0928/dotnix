{ delib, pkgs, ... }:
delib.module {
  name = "programs.cloudflared";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = [ pkgs.cloudflared ];
}
