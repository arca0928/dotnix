{
  flake.modules.homeManager.shell =
    { pkgs, lib, ... }:
    {
      programs.zsh = {
        enable = true;
        initContent =
          let
            earlyInit = lib.mkBefore ''
              if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
                source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
              fi
            '';
            Init = ''
              [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
            '';
          in
          lib.mkMerge [
            earlyInit
            Init
          ];
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
        autosuggestion.enable = true;
        autocd = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
      };
    };

  flake.modules.darwin.base = {
    environment.pathsToLink = [ "/share/zsh" ];
  };

  flake.modules.nixos.base = {
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
