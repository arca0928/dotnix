{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim = {
    plugins = {
      lspconfig = {
        enable = true;

        autoLoad = true;
      };
    };

    lsp = {
      servers = {
        nixd.enable = true;
        nil.enable = true;
        biome.enable = true;
        astro.enable = true;
        clangd.enable = true;
        rust_analyzer.enable = true;
        tailwindcss.enable = true;
        tinymist.enable = true;
      };
    };
  };
}
