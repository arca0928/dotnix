{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.keepassxc";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.keepasxac = {
      enable = true;

      settings = {
        Browser.Enabled = true;
        Browser.SearchInAllDatabases = true;

        GUI = {
          ApplicationTheme = "dark";
          MinimizeOnClose = true;
          MinimizeToTray = true;
          ToolButtonStyle = 0;
        };
        Security.IconDownloadFallback = true;
      };
    };
  };
}
