{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "ime";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    i18n = {
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          fcitx5-skk
          kdePackages.fcitx5-qt
          fcitx5-gtk
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      skkDictionaries.l
    ];
  };
}
