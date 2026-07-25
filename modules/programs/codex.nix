{ delib, host, ... }:
delib.module {
  name = "programs.codex";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.codex = {
      enable = true;
    };
  };
}
