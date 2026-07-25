{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    conform-nvim = {
      enable = true;
    };
  };
}
