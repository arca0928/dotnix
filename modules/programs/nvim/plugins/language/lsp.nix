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
        nushell.enable = true;
        biome.enable = true;
        basedpyright.enable = true;
        denols.enable = true;
        astro.enable = true;
        clangd.enable = true;
        rust_analyzer.enable = true;
        tailwindcss.enable = true;
        tinymist.enable = true;
        fennel_ls.enable = true;
      };
    };
  };
}
