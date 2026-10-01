{ delib, config, ... }:
delib.host {
  name = "cifera";
  type = "laptop";

  features = [
    "secureboot"
    "fingerprint"
    "xremap"
  ];

  nixos = {
    sops.defaultSopsFile = ../../secrets/hosts/cifera.yaml;

    sops.secrets = {
      cloudflared_cifera_token = {
        owner = "cloudflared";
        group = "cloudflared";
        mode = "0400";
      };
    };
  };

  myconfig.services.cloudflared.tokenFile = config.sops.secrets.cloudflared_cifera_token.path;
}
