{
  flake.modules.homeManager.guiApps =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        extensions = [
          "0x96f"
          "nix"
        ];
        extraPackages = with pkgs; [
          nixd
        ];
        userSettings = {
          vim_mode = true;
          indent_guides = {
            enabled = true;
            coloring = "indent_aware";
            background_coloring = "indent_aware";
          };
          theme = "0x96f Theme";
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
            context = "vim_mode == insert";
            bindings = {
              ctrl-enter = "editor::MoveToEnclosingBracket";
              ctrl-y = "editor::ConfirmCompletion";
            };
          }
        ];
      };
    };
}
