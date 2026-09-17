{ delib, pkgs, ... }:
delib.module {
  name = "services.cloudflared";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;
      tokenFile = noDefault (strOption null);
    };

  nixos.ifEnabled = { cfg, ... }: {
    systemd.services.cloudflared = {
      description = "Cloudflare Tunnel";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = "cloudflared";
        Group = "cloudflared";

        ExecStart = ''
          ${pkgs.cloudflared}/bin/cloudflared tunnel run \
            --token-file ${cfg.tokenFile}
        '';

        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
