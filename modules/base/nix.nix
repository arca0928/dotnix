{
  flake.modules.nixos.base = {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      settings.extra-substituters = [
        "https://zed.cachix.org"
        "https://cache.garnix.io"
      ];
      settings.extra-trusted-public-keys = [
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
    nixpkgs.config.allowUnfree = true;
  };

  flake.modules.darwin.base = {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      settings.extra-substituters = [
        "https://zed.cachix.org"
        "https://cache.garnix.io"
      ];
      settings.extra-trusted-public-keys = [
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
    nixpkgs.config.allowUnfree = true;
  };
}
