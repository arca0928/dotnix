{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    noice = {
      enable = true;
    };
    notify.enable = true;
  };
}
