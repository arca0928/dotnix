{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "xdg";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.ifEnabled = {
    xdg.portal = {
      enable = true;
      config = {
        common.default = "*";

        shojiwm = {
          default = "shojiwm";
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
  home.ifEnabled = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };
}
