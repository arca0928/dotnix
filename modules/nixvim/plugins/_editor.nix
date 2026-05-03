{ config, ... }:
{
  plugins = {
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
      };
      lazyLoad.settings.event = "InsertEnter";
    };

    hlchunk = {
      enable = true;
      lazyLoad.settings.event = [
        "BufReadPre"
        "BufNewFile"
      ];

      settings = {
        chunk = {
          enable = true;
          use_treesitter = true;
        };
        line_num.enable = true;
        indent.enable = true;
      };
    };
    zen-mode = {
      enable = true;
      lazyLoad.settings.cmd = "ZenMode";
    };
    treesitter = {
      enable = true;
      highlight.enable = true;
      folding.enable = true;
      indent.enable = true;

      grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        nix
        lua
        bash
        nu
        python
      ];
    };

    conform-nvim = {
      enable = true;
      autoInstall.enable = true;
      settings = {
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
        };
      };
    };

    dial = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = [ "InsertEnter" ];
      };
    };
  };
}
