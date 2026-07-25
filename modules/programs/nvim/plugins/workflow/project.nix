{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    project-nvim = {
      enable = true;

      enableTelescope = true;
    };
  };
}
