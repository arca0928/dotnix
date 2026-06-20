{ delib, host, ... }:
delib.module {
  name = "programs.ghostty";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.ghostty = {
      enable = true;
    };
  };
}
