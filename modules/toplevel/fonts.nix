{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "fonts";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      ipaexfont
    ];
  };

  home.ifEnabled = {
    home.packages = with pkgs; [
      moralerspace
    ];
    fonts.fontconfig.enable = true;
  };
}
