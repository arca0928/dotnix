{
  flake.modules.nixos.tailscale = {
    services.tailscale = {
      enable = true;
      interfaceName = "tailnet0";
    };

    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
  };

  flake.modules.darwin.tailscale = {
    services.tailscale = {
      enable = true;
    };
  };
}
