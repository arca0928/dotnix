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
          extraGroups = [
            "networkmanager"
            "wheel"
            "wireshark"
          ];
          packages = [
            pkgs.wireshark
          ];
        };
      };
  };
}
