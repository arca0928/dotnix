{ delib, host, ... }:
delib.module {
  name = "programs.zoxide";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    enable = true;
    enableZshIntegration = true;
  };
}
