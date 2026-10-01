{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.keepassxc";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.keepassxc = {
      enable = true;

      settings = {
        Browser.Enabled = true;
        Browser.SearchInAllDatabases = true;

        GUI = {
          ApplicationTheme = "dark";
          ToolButtonStyle = 0;
        };
        Security.IconDownloadFallback = true;
      };
    };
  };
}
