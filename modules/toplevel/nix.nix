{ delib, ... }:
delib.module {
  name = "nix";

  nixos.always = {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        extra-substituters = [
          "https://zed.cachix.org"
        ];

        extra-trusted-public-keys = [
          "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        ];
      };
    };
  };
}
