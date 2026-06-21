{ delib, host, ... }:
delib.module {
  name = "programs.zoxide";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
