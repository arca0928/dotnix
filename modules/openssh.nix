{
  flake.modules.nixos.openssh = {
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
        AllowUsers = [ "arca" ];
        PermitRootLogin = "no";
      };
    };
  };
}
