{
  flake.modules.homeManager.vicinae = {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
      settings = {
        telemetry = {
          system_info = false;
        };
        pop_to_root_on_close = true;
        keybinding = "emacs";
      };
    };
  };
}
