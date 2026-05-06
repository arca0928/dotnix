{
  flake.modules.homeManager.guiApps =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "0x96f"
          "astro"
          "biome"
          "git-firefly"
          "unocss"
          "nix"
        ];
        extraPackages = with pkgs; [
          nixd
          nil
        ];

        mutableUserSettings = false;
        mutableUserKeymaps = false;

        userSettings = {
          vim_mode = true;
          indent_guides = {
            enabled = true;
            coloring = "indent_aware";
            background_coloring = "indent_aware";
          };
          theme = "0x96f Theme";
          buffer_font_family = "Moralerspace Neon";

          buffer_font_features = {
            calt = true;
            liga = true;
            ss01 = true;
            ss02 = true;
            ss03 = true;
            ss04 = true;
            ss05 = true;
            ss06 = true;
            ss07 = true;
            ss08 = true;
            ss09 = true;
            ss10 = true;
          };
          terminal = {
            font_family = "Moralerspace Neon";
            font_features = {
              calt = true;
              liga = true;
              ss01 = true;
              ss02 = true;
              ss03 = true;
              ss04 = true;
              ss05 = true;
              ss06 = true;
              ss07 = true;
              ss08 = true;
              ss09 = true;
              ss10 = true;
            };

            telemetry = {
              diagnostics = false;
              metrics = false;
            };
          };
        };
        userKeymaps = [
          {
            context = "vim_mode == normal || vim_mode == visual";
            bindings = {
              k = "vim::Left";
              t = "vim::Down";
              n = "vim::Up";
              s = "vim::Right";
            };
          }
          {
            context = "vim_mode == normal";
            bindings = {
              j = "vim::MoveToNextMatch";
              J = "vim::MoveToPreviousMatch";
            };
          }
          {
            context = "Editor && vim_mode == insert";
            bindings = {
              ctrl-enter = "editor::MoveToEndOfLargerSyntaxNode";
              ctrl-y = "editor::ConfirmCompletion";
            };
          }
        ];
      };
    };
}
