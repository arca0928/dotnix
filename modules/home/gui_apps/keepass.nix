{
  flake.modules.homeManager.guiApps = {
    programs.keepassxc = {
      enable = true;

      settings = {
        Browser.Enabled = true;
        Browser.SearchInAllDatabases = true;

        GUI = {
          ApplicationTheme = "dark";
          MinimizeOnClose = true;
          MinimizeToTray = true;
          ShowTrayIcon = true;
          ToolButtonStyle = 0;
        };

        Security.IconDownloadFallback = true;
      };
    };
  };
}
