{ delib, pkgs, ... }:
delib.module {
  name = "user";

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) username;
    in
    {
      users = {
        groups.${username} = { };

        users.${username} = {
          isNormalUser = true;
          home = "/home/${username}";
          shell = pkgs.zsh;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
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
