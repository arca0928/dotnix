{ delib, pkgs, ... }:
delib.module {
  name = "user";

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) username;
    in
    {
      virtualisation.vmVariant = {
        users.mutableUsers = false;
        users.users.${username}.password = username;
      };

      users = {
        groups.${username} = { };
        groups.cloudflared = { };

        users.${username} = {
          isNormalUser = true;
          home = "/home/${username}";
          homeMode = "0700";
          shell = pkgs.zsh;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };

        users.cloudflared = {
          isSystemUser = true;
          group = "cloudflared";
        };
      };
    };
  darwin.always =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) username;
    in
    {
      users.users.${username} = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
      };
    };
}
