{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.opts = {
    number = true;
    relativenumber = true;

    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    smartindent = true;
    autoindent = true;

    smartcase = true;
    ignorecase = true;

    autoread = true;
    swapfile = false;
  };
}
