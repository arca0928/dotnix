{
  delib,
  ...
}:
delib.module {
  name = "programs.zed-editor";

  home.ifEnabled.programs.zed-editor.useSettings = {

    vim_mode = true;
    indent_guides = {
      enabled = true;
      coloring = "indent_aware";
      background_coloring = "indent_aware";
    };
    theme = "0x96f Theme";
    buffer_font_family = "Moralerspace Neon";

    load_direnv = "shell_hook";

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

    lsp = {
      tinymist = {
        settings = {
          exportPdf = "onSave";
          outputPath = "$root/$dir/$name";
        };
      };
    };
  };
}
