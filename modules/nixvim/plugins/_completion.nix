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
          ];
        };
        cmdline = {
          keymap = {
            preset = "inherit";
          };
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
