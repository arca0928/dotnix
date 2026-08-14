{ delib, ... }:
delib.host {
  name = "khaslana";
  type = "desktop";

  features = [ "wifi" ];

  myconfig.programs.emacs.enable = false;
}
