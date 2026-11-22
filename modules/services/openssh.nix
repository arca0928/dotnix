{ delib, ... }:
delib.module {
  name = "openssh";

  options = delib.singleEnableOption true;

  nixos.ifEnabled =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) username;
    in
    {
      users.users.${username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS3lm5LcPgcRXPZmVtlQ903o9czBQLXC4DH+faoVHXD"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA6cac6ujAYARL5iyNrbsAoTaaUkplJ0MNWqufw8Kh5T"
      ];

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
          KbdInteractiveAuthentication = false;
          AllowUsers = [ username ];
          PermitRootLogin = "no";
        };
      };
    };
}
