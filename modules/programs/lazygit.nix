{ delib, host, ... }:
delib.module {
  name = "programs.lazygit";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.lazygit = {
      enable = true;
    };
  };
}
