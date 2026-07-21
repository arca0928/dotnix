{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;

      settings = {
        keymap.preset = "default";
        cmdline = {
          keymap.preset = "inherit";

          completion.menu.auto_show = true;
        };

        signature.enabled = true;

        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
      };
    };
  };
}
