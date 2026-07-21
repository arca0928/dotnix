{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    typst-preview = {
      enable = true;

      lazyLoad.settings.ft = "typst";
    };
  };
}
