{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    toggleterm = {
      enable = true;

      settings = {
        open_mapping = "[[<C-t>]]";
        direction = "float";
        float_opts = {
          border = "curved";
        };
      };
    };
  };
}
