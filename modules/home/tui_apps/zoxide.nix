{
  flake.modules.homeManager.tuiApps = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
