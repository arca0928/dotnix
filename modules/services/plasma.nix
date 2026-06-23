{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "services.plasma";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    services.desktopManager.plasma6 = {
      enable = true;

    };
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      konsole
      kate
      kwallet
      kwalletmanager
      ktexteditor
    ];
  };
}
