{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.files = {
    "ftplugin/nix.lua" = {
      localOpts = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
      };
    };
  };
}
