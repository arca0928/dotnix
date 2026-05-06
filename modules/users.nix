{
  flake = {
    meta.users = {
      arca = {
        username = "arca";
      };
    };
    modules.nixos.arca =
      { pkgs, ... }:
      {
        users.users.arca = {
          isNormalUser = true;
          home = "/home/arca/";
          shell = pkgs.zsh;
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          packages = [
          ];
        };
      };
    modules.darwin.arca =
      { pkgs, ... }:
      {
        users.users.arca = {
          home = "/Users/arca";
          shell = pkgs.zsh;
        };
      };
  };
}
