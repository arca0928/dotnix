{ delib, ... }:
delib.module {
  name = "programs.zed-editor";

  home.ifEnabled.programs.zed-editor.userKeymaps = [
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
}
