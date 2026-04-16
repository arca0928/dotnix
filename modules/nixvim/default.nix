{
  flake.modules.homeManager.nixvim = { pkgs, inputs, ... }:
  let
  colorscheme = pkgs.vimUtils.buildVimPlugin {
    name = "0x96f.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "filipjanevski";
      repo = "0x96f.nvim";
      rev = "188c2be71a4e046df7cea095ccd61a520ee21249";
      sha256 = "sha256-mr/OHxmZAXdaYSldIgesFHyzmyT4e8nSz2gR16iS4GE=";
    };
  };
  in
  {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;

      imports = [
        ./plugins/_default.nix
        ./_keymaps.nix
        ./_lsp.nix
        ./_options.nix
      ];

      viAlias = true;
      vimAlias = true;

      clipboard.providers.wl-copy.enable = true;

      extraPlugins = [
        colorscheme
      ];

      performance.byteCompileLua.enable = true;

      colorscheme = "0x96f";

      globals = {
        mapleader = " ";
      };

      dependencies = {
        tree-sitter = {
          enable = true;
        };
        ripgrep = {
          enable = true;
        };
      };
    };
  };
}
