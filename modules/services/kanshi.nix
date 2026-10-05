{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "services.kanshi";

  options = delib.singleEnableOption (host.isLaptop && pkgs.stdenv.hostPlatform.isLinux);

  home.ifEnabled = {
    services.kanshi = {
      enable = true;

      settings = [
        {
          output = {
            criteria = "eDP-1";
            mode = "2880x1800@120Hz";
            scale = 1.25;
            alias = "INTERNAL";
            adaptiveSync = true;
          };
        }
        {
          output = {
            criteria = "Eizo Nanao Corporation FS2333 *";
            mode = "1920x1080@60Hz";
            scale = 1.0;
            alias = "HOME_1";
          };
        }

        {
          profile = {
            name = "mobile";

            outputs = [
              {
                criteria = "$INTERNAL";
                status = "enable";
                position = "0,0";
              }
            ];
          };
        }

        {
          profile = {
            name = "home";

            outputs = [
              {
                criteria = "$HOME_1";
                status = "enable";
                position = "0,180";
              }
              {
                criteria = "$INTERNAL";
                status = "enable";
                position = "1920,0";
              }
            ];
          };
        }
      ];
    };
  };
}
