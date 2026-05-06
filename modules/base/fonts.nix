{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
      ];
    };
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.moralerspace
      ];
      fonts.fontconfig.enable = true;
    };
}
