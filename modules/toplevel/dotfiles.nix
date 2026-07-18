{ delib, ... }:
delib.module {
  name = "dotfiles";

  options = delib.singleEnableOption true;

  home.ifEnabled = {
    home.file = {
      ".pi/" = {
        source = ../../dots/.pi;
        recursive = true;
      };
    };
  };
}
