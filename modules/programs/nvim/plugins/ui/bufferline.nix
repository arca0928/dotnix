{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    bufferline = {
      enable = true;
    };
  };
}
