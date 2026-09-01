{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "xdg";

  nixos.always = {
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
  home.always = {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
  };
}
