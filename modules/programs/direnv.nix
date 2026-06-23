{ delib, host, ... }:
delib.module {
  name = "programs.direnv";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
