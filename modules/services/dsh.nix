{
  delib,
  config,
  lib,
  mypkgs,
  pkgs,
  ...
}:
delib.module {
  name = "services.dsh";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;
      package = packageOption mypkgs.dsh;
      user = strOption config.myconfig.constants.username;
      dataDir = allowNull (pathOption null);
      workingDirectory = allowNull (pathOption null);
      listenAddress = strOption "127.0.0.1";
      port = portOption 3080;
      publicUrl = allowNull (strOption null);
      trustedHosts = listOfOption str [ ];
      extraPatches = listOfOption attrs [ ];
      chatgptAuthHelper = boolOption false;
      extraPackages = listOfOption package [ ];
    };

  nixos.ifEnabled =
    { cfg, ... }:
    let
      utils = import (pkgs.path + "/nixos/lib/utils.nix") { inherit config lib pkgs; };
      account = config.users.users.${cfg.user};
      dataDir = if cfg.dataDir == null then "${account.home}/.dsh" else cfg.dataDir;
      workingDirectory = if cfg.workingDirectory == null then account.home else cfg.workingDirectory;
      servicePatch = pkgs.writeText "dsh-service.patch.yml" (builtins.toJSON cfg.extraPatches);
      authPlugin = pkgs.writeText "dsh-chatgpt-auth.mjs" (builtins.readFile ./dsh/chatgpt-auth.mjs);
      authPatch = pkgs.writeText "dsh-chatgpt.patch.yml" (
        builtins.toJSON [
          {
            id = "sdk-app-startup";
            disabled = true;
          }
          {
            id = "sdk-jsonrpc-server";
            disabled = true;
          }
          {
            id = "schedule";
            disabled = true;
          }
          {
            insert = [
              {
                id = "dotnix-chatgpt-auth";
                name = toString authPlugin;
              }
            ];
          }
        ]
      );
      authHelper = pkgs.writeShellScriptBin "dsh-chatgpt" ''
        set -eu
        if [ "$(id -un)" != ${lib.escapeShellArg cfg.user} ]; then
          echo ${lib.escapeShellArg "Run as ${cfg.user}: sudo -iu ${cfg.user} dsh-chatgpt <login|status|logout>"} >&2
          exit 1
        fi
        if [ "$#" -ne 1 ]; then
          echo 'Usage: dsh-chatgpt <login|status|logout>' >&2
          exit 2
        fi
        case "$1" in
          login|status|logout) export DSH_CHATGPT_ACTION="$1" ;;
          *) echo 'Usage: dsh-chatgpt <login|status|logout>' >&2; exit 2 ;;
        esac
        umask 077
        export HOME=${lib.escapeShellArg account.home}
        export DSH_HOME=${lib.escapeShellArg dataDir}
        cd "$HOME"
        exec ${cfg.package}/bin/dsh sdk --patch ${authPatch}
      '';
      accessUrl = pkgs.writeShellScriptBin "dsh-access-url" ''
        set -eu
        if [ "$(id -u)" -ne 0 ]; then
          echo 'Run: sudo dsh-access-url' >&2
          exit 1
        fi
        if ! ${pkgs.systemd}/bin/systemctl is-active --quiet dsh.service; then
          echo 'DSH is not running.' >&2
          exit 1
        fi
        invocation=$(${pkgs.systemd}/bin/systemctl show dsh.service --property=InvocationID --value)
        if [[ ! "$invocation" =~ ^[0-9a-f]{32}$ ]]; then
          echo 'Cannot identify the current DSH invocation.' >&2
          exit 1
        fi
        url=$(${pkgs.systemd}/bin/journalctl --quiet --unit=dsh.service \
          "_SYSTEMD_INVOCATION_ID=$invocation" --output=cat --no-pager \
          | ${pkgs.gnused}/bin/sed -nE 's,.*(https?://[^[:space:]]+[?&]token=[A-Za-z0-9_-]+).*,\1,p' \
          | ${pkgs.coreutils}/bin/tail -n 1)
        current=$(${pkgs.systemd}/bin/systemctl show dsh.service --property=InvocationID --value)
        if [ "$current" != "$invocation" ] || [ -z "$url" ]; then
          echo 'No current launch URL is available yet; retry after DSH has started.' >&2
          exit 1
        fi
        printf '%s\n' "$url"
      '';
      args = [
        "${cfg.package}/bin/dsh"
        "web"
      ]
      ++ lib.optionals (cfg.extraPatches != [ ]) [
        "--patch"
        (toString servicePatch)
      ]
      ++ [
        "--no-open"
        "--host"
        cfg.listenAddress
        "--port"
        (toString cfg.port)
      ]
      ++ lib.optionals (cfg.publicUrl != null) [
        "--public-url"
        cfg.publicUrl
      ]
      ++ lib.concatMap (authority: [
        "--trusted-host"
        authority
      ]) cfg.trustedHosts;
    in
    {
      assertions = [
        {
          assertion = cfg.user != "root";
          message = "services.dsh must run as an existing non-root user.";
        }
      ];

      users.users.${cfg.user}.packages = [
        cfg.package
      ]
      ++ lib.optional cfg.chatgptAuthHelper authHelper
      ++ cfg.extraPackages;

      environment.systemPackages = [ accessUrl ];

      systemd.tmpfiles.rules = [
        "d ${lib.escapeShellArg dataDir} 0700 ${cfg.user} ${account.group} -"
      ];

      systemd.services.dsh = {
        description = "DeepSeek Harness Web server";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
          "systemd-tmpfiles-setup.service"
        ];
        unitConfig.RequiresMountsFor = [
          account.home
          dataDir
          workingDirectory
        ];

        path = [
          "/etc/profiles/per-user/${cfg.user}"
          "/run/current-system/sw"
        ]
        ++ cfg.extraPackages;

        environment = {
          HOME = account.home;
          DSH_HOME = dataDir;
        };

        serviceConfig = {
          User = cfg.user;
          Group = account.group;
          WorkingDirectory = workingDirectory;
          ExecStart = utils.escapeSystemdExecArgs args;
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStopSec = "30s";
          UMask = "0077";
          NoNewPrivileges = true;
        };
      };
    };
}
