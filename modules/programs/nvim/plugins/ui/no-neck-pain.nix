{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    no-neck-pain = {
      enable = true;

      settings = {
        autocmds = {
          enableOnVimEnter = true;
        };
      };
    };
  };
}
