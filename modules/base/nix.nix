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
        "https://hyprland.cachix.org"
        "https://wezterm.cachix.org"
      ];
      settings.extra-trusted-public-keys = [
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
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
