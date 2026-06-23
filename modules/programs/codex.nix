{ delib, host, ... }:
delib.module {
  name = "programs.codex";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.codex = {
      enable = true;
    };
  };
}
