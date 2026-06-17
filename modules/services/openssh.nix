{ delib, host, ... }:
delib.module {
  name = "openssh";

  options = delib.singleEnableOption (host.isDesktop or host.isServer);

  nixos.ifEnabled =
    { myconfig, ... }:
    {
      services.openssh = {
        enable = true;

        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];

        settings = {
          PasswordAuthentication = false;
          AllowUsers = [ "${myconfig.constants.username}" ];
          PermitRootLogin = "no";
        };
      };
    };
}
