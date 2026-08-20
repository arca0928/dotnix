{
  delib,
  inputs,
  host,
  lib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.wezterm";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;

    settings = {
      color_scheme = "OneDark (base16)";

      front_end = "WebGpu";
      max_fps = 120;

      font = lib.generators.mkLuaInline ''
        wezterm.font({
          family = "Moralerspace Neon",
          harfbuzz_features = {
            "+liga",
            "+calt",
            "+ss01",
            "+ss02",
            "+ss03",
            "+ss04",
            "+ss05",
            "+ss06",
            "+ss07",
            "+ss08",
            "+ss09",
            "+ss10",
          },
        })
      '';

      use_ime = true;
      enable_wayland = true;

      window_background_opacity = 0.6;
      wayland_window_background_blur = true;
    };
  };
}
