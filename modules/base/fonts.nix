{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji

        skkDictionaries.l
      ];
    };
  flake.modules.homeManager.base = {pkgs, ...}:{
    home.packages = [
      pkgs.moralerspace
    ];
  };
}
