{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    blink-pairs = {
      enable = true;
    };
  };
}
