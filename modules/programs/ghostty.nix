{ delib, host, ... }:
delib.module {
  name = "programs.ghostty";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        font-family = "Moralerspace Neon";
        font-feature = [
          "+liga"
          "+calt"
          "+ss01"
          "+ss02"
          "+ss03"
          "+ss04"
          "+ss05"
          "+ss06"
          "+ss07"
          "+ss08"
          "+ss09"
          "+ss10"
        ];
        theme = "0x96f";
        cursor-style = "block";
        cursor-style-blink = false;
        shell-integration-features = "no-cursor";

        background-opacity = 0.55;
        background-blur = true;

        keybind = [
          "ctrl+enter=unbind"
        ];
      };
    };
  };
}
