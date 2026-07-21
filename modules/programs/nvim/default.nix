{ delib, inputs, ... }:
delib.module {
  name = "programs.nixvim";

  options = delib.singleEnableOption true;

  home.always.imports = [ inputs.nixvim.homeModules.nixvim ];

  home.ifEnabled = {
    programs.nixvim = {
      enable = true;

      viAlias = true;
      waylandSupport = true;

      editorconfig.enable = true;
      clipboard.register = "unnamedplus";
      colorschemes.onedark.enable = true;

      globals.mapleader = " ";

      performance.byteCompileLua.enable = true;

      dependencies = {
        ripgrep.enable = true;
      };
    };
  };
}
