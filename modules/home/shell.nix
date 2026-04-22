{
  flake.modules.homeManager.shell =
    { pkgs, lib, ... }:
    {
      programs.zsh = {
        enable = true;
        initContent =
          let
            earlyInit = lib.mkOrder 500 ''
              if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
                source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
              fi
            '';
            themeInit = lib.mkOrder 800 ''
              source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            '';
            p10kInit = lib.mkOrder 1000 ''
              [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
            '';
          in
          lib.mkMerge [
            earlyInit
            themeInit
            p10kInit
          ];
        autosuggestion.enable = true;
        autocd = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          cd = "z";
        };
      };
    };

  flake.modules.darwin.base = {
    environment.pathsToLink = [ "/share/zsh" ];
  };

  flake.modules.nixos.base = {
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
