{
  delib,
  host,
  ...
}:
delib.module {
  name = "networking";

  nixos.always = {
    networking = {
      networkmanager.enable = true;

      hostName = host.name;
      nftables.enable = true;

      firewall = {
        enable = true;
      };
    };
  };
}
