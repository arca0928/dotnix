{
  flake.modules.homeManager.dots = {
    xdg.configFile = {
      "wezterm".source = ./dots/wezterm;
      # "quickshell".source = ./dots/quickshell;
    };
    home.file.".p10k.zsh".source = ./dots/.p10k.zsh;
  };
}
