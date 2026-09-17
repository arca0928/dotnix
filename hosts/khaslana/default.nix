{ delib, config, ... }:
delib.host {
  name = "khaslana";
  type = "desktop";

  features = [ "wifi" ];

  nixos = {
    sops.defaultSopsFile = ../../secrets/hosts/khaslana.yaml;

    sops.secrets = {
      cloudflared_khaslana_token = {
        owner = "cloudflared";
        group = "cloudflared";
        mode = "0400";
      };
    };
  };

  myconfig.services.cloudflared.tokenFile = config.sops.secrets.cloudflared_khaslana_token.path;

  myconfig.programs.emacs.enable = false;
}
