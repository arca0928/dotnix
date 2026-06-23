{ delib, ... }:
delib.module {
  name = "programs.zsh";

  options = delib.singleEnableOption true;

  home.ifEnabled.programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cd = "z";
    };
  };

  nixos.ifEnabled = {
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];
  };

  darwin.ifEnabled = {
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
