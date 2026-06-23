{ delib, host, ... }:
delib.module {
  name = "programs.vesktop";
  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.vesktop = {
      enable = true;
    };
  };
}
