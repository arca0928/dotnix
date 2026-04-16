{
  flake.modules.homeManager.dots = {
    xdg.configFile = {
      "wezterm".source = ./dots/wezterm;
    };
  };
}
