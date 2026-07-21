{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    ts-autotag = {
      enable = true;
    };
  };
}
