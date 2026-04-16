{
  lsp = {
    inlayHints.enable = true;
    servers = {
      nixd = {
        enable = true;
      };
      ruff = {
        enable = true;
      };
      pyright = {
        enable = true;
      };
    };
  };
}
