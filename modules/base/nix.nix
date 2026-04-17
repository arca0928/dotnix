{
  flake.modules.nixos.base = {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
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
    };
    nixpkgs.config.allowUnfree = true;
  };
}
