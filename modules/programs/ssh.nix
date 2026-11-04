{
  delib,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ssh";

  options = delib.singleEnableOption true;

  home.ifEnabled =
    { myconfig, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings.khaslana = {
          HostName = "khaslana.arca0928.dev";
          User = myconfig.constants.username;
          ProxyCommand = "${lib.getExe pkgs.cloudflared} access ssh --hostname %h";
        };
      };
    };
}
