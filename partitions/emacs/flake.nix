{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    twist.url = "github:emacs-twist/twist.nix";
    org-babel.url = "github:emacs-twist/org-babel";
  };

  outputs = inputs: {
    inherit inputs;
  };
}
