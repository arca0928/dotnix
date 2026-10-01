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
      ipafont
    ];
  };

  home.ifEnabled =
    let
      mapleMono = pkgs.maple-mono.NF-unhinted.overrideAttrs (old: {
        pname = "MapleMono-NF-JP-unhinted";
        version = "8.0-beta.3";

        src = pkgs.fetchurl {
          url = "https://github.com/subframe7536/maple-font/releases/download/v8.0-beta.3/MapleMono-NF-JP-unhinted.zip";
          hash = "sha256-ita9GvP1zYYlBJXi0xvws6UzZ4GwDCuPeqlvX4XllyA=";
        };
      });
    in
    {
      home.packages = with pkgs; [
        moralerspace
        mapleMono
      ];
      fonts.fontconfig.enable = true;
    };
}
