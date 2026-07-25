{ delib, host, ... }:
delib.module {
  name = "programs.lazygit";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.lazygit = {
      enable = true;
    };
  };
}
