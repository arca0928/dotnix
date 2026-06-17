{ delib, ... }:
delib.module {
  name = "darwin";

  darwin.always =
    { myconfig, ... }:
    {
      system.primaryUser = myconfig.constants.username;
      security.pam.services.sudo_local = {
        touchIdAuth = true;
        reattach = true;
      };
    };
}
