{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "spell"
          ];

          providers = {
            spell = {
              module = "blink-cmp-spell";
              name = "spell";
              score_offset = 100;
            };
          };
        };
        cmdline = {
          keymap = { preset = "inherit"; };
          completion = {
              menu = {
              auto_show = true;
            };
          };
        };
      };
    };

    luasnip = {
      enable = true;
    };

    friendly-snippets.enable = true;
  };
}
