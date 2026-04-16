{ ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    i18n = {
      supportedLocales = [
        "ja_JP.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];

      defaultLocale = "ja_JP.UTF-8";
      extraLocaleSettings = {
        LANGUAGE = "ja_JP.UTF-8";
        LC_ALL = "ja_JP.UTF-8";
        LC_CTYPE = "ja_JP.UTF8";
        LC_ADDRESS = "ja_JP.UTF8";
        LC_IDENTIFICATION = "ja_JP.UTF8";
        LC_MEASUREMENT = "ja_JP.UTF8";
        LC_MESSAGES = "ja_JP.UTF-8";
        LC_MONETARY = "ja_JP.UTF8";
        LC_NAME = "ja_JP.UTF8";
        LC_NUMERIC = "ja_JP.UTF-8";
        LC_PAPER = "ja_JP.UTF8";
        LC_TELEPHONE = "ja_JP.UTF8";
        LC_TIME = "ja_JP.UTF8";
        LC_COLLATE = "ja_JP.UTF8";
      };

      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-skk
          kdePackages.fcitx5-qt
          fcitx5-gtk
        ];
      };
    };

    time.timeZone = "Asia/Tokyo";
  };
}
