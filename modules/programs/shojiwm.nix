{
  delib,
  host,
  pkgs,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "programs.shojiwm";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.always.imports = [
    inputs.shojiwm.nixosModules.default
  ];

  nixos.ifEnabled = { myconfig, ... }: {
    programs.shojiwm = {
      enable = true;
      initConfig = {
        enable = true;
        users = [ myconfig.constants.username ];
      };
      xwaylandSatellite.package =
        inputs.xwayland-satellite-shojiwm.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  home.ifEnabled = {
    xdg.configFile = {
      "shojiwm" = {
        source = ../../dots/shojiwm;
        recursive = true;
      };
    };
  };
}
