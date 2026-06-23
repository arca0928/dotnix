{ delib, inputs, ... }:
delib.overlayModule {
  name = "overlays.emacs";

  enabled = true;

  targets = [
    "nixos"
    "home"
    "darwin"
  ];

  overlays = [
    inputs.emacs-overlay.overlay
    inputs.org-babel.overlays.default
  ];
}
