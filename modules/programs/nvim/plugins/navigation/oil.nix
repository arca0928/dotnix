{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    oil = {
      enable = true;

      lazyLoad.settings.cmd = "Oil";

      settings = {
        view_options = {
          show_hidden = true;
        };
        win_opitons = {
          signcolumn = "yes:2";
        };
      };
    };
    oil-git-status = {
      enable = true;

      lazyLoad.settings.ft = "oil";
    };
  };
}
