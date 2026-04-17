{
  flake.modules.homeManager.dots = {
    xdg.configFile = {
      "wezterm".source = ./dots/wezterm;
    };
    home.file.".p10k.zsh".source = ./dots/.p10k.zsh;
  };
}
