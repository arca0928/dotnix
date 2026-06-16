{ delib, ... }:
delib.module {
  name = "nixpkgs";

  nixos.always = {
    nixpkgs.config.allowUnfree = true;
  };

  darwin.always = {
    nixpkgs.config.allowUnfree = true;
  };

  home.always = {
    nixpkgs.config.allowUnfree = true;
  };
}
