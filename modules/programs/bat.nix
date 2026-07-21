{ delib, host, ... }:
delib.module {
  name = "programs.bat";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.bat = {
      enable = true;
    };
  };
}
