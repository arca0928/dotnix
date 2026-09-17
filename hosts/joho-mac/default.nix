{ delib, ... }:
delib.host {
  name = "joho-mac";

  type = "desktop";

  myconfig.programs.emacs.enable = false;
}
