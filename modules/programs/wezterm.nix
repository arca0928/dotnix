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

    extraConfig = ''
      wezterm.on('user-var-changed', function(window, pane, name, value)
        local overrides = window:get_config_overrides() or {}
        if name == "ZEN_MODE" then
          local incremental = value:find("+")
          local number_value = tonumber(value)
          if incremental ~= nil then
            while (number_value > 0) do
              window:perform_action(wezterm.action.IncreaseFontSize, pane)
              number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
          elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
          else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
          end
        end
        window:set_config_overrides(overrides)
      end)
    '';
  };
}
