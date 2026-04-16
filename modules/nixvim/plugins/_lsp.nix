{
  plugins = {
    lspconfig = {
      enable = true;
      lazyLoad.settings.event = [ "BufReadPre" "BufNewFile" ];
    };
  };
}
