{ delib, host, ... }:
delib.module {
  name = "programs.obsidian";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.programs.obsidian = {
    enable = true;

    cli.enable = true;

    defaultSettings.app = {
      vimMode = true;
      useTab = false;
    };
  };
}
