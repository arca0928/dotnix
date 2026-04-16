{
  flake.modules.nixos.base = { config, hostConfig, ... }: {
      networking = {
        networkmanager.enable = true;
        hostName = hostConfig.name;
        nftables.enable = true;
        firewall = {
          enable = true;
          trustedInterfaces = [ "tailnet0" ];
          allowedUDPPorts = [
            config.services.tailscale.port
          ];
        };
      };
    };
}
