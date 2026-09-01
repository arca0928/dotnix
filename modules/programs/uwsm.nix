{ delib, host, ... }:
delib.module {
  name = "programs.uwsm";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled.programs.uwsm = {
    enable = true;

    waylandCompositors = {
      shojiwm = {
        prettyName = "ShojiWM";
        binPath = "/run/current-system/sw/bin/shoji_wm";
        comment = "ShojiWM session managed by UWSM";
        extraArgs = [ "--tty" ];
      };
    };
  };
}
