{
  delib,
  config,
  pkgs,
  ...
}:
delib.host {
  name = "khaslana";
  type = "server";

  features = [ "wifi" ];

  nixos = {
    users.groups = {
      agent = { };
      projects.members = [
        "arca"
        "agent"
      ];
    };

    users.users.agent = {
      isNormalUser = true;
      description = "Agent workspace user";
      group = "agent";
      home = "/home/agent";
      homeMode = "0700";
      shell = pkgs.zsh;
      linger = true;
      packages = with pkgs; [
        git
        codex
        pi-coding-agent
        herdr
      ];
    };

    systemd.tmpfiles.rules = [
      "d /srv/projects 2770 root projects -"
      # Inherit group write access even when a tool uses a restrictive umask.
      "a+ /srv/projects - - - - default:user::rwx,default:group::rwx,default:mask::rwx,default:other::---"

      "d /home/agent/.codex 0700 agent agent -"
      # Seed once; keep OAuth state mutable.
      "f /home/agent/.codex/config.toml 0600 agent agent - cli_auth_credentials_store = \"file\""
      "z /home/agent/.codex/auth.json 0600 agent agent -"
    ];

    sops.defaultSopsFile = ../../secrets/hosts/khaslana.yaml;

    sops.secrets = {
      cloudflared_khaslana_token = {
        owner = "cloudflared";
        group = "cloudflared";
        mode = "0400";
      };
    };
  };

  myconfig.services = {
    cloudflared.tokenFile = config.sops.secrets.cloudflared_khaslana_token.path;
    dsh = {
      enable = true;
      user = "agent";
      workingDirectory = "/srv/projects";
      publicUrl = "https://dsh.arca0928.dev/";
      trustedHosts = [ "dsh.arca0928.dev" ];
      chatgptAuthHelper = true;
      extraPatches = [
        {
          id = "llm-pi-ai";
          config.providers.openai-codex = {
            # Explicit lists replace the catalog: retain all installed models.
            models =
              map (id: { inherit id; }) [
                "gpt-5.3-codex-spark"
                "gpt-5.5"
                "gpt-5.6-luna"
                "gpt-5.6-sol"
                "gpt-5.6-terra"
                "gpt-6-astra"
                "gpt-6-luna"
                "gpt-6-sol"
                "gpt-6.1-sol"
              ]
              ++ [
                {
                  id = "gpt-6.1-terra";
                  name = "GPT-6.1 Terra";
                  # Capacity and modalities use adapter defaults until verified.
                  reasoningEfforts.medium = "medium";
                }
              ];
          };
        }
        {
          id = "agent-default-model";
          config = {
            provider = "openai-codex";
            model = "gpt-6.1-sol";
            reasoningEffort = "medium";
          };
        }
      ];
    };
  };
}
