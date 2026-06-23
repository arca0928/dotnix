{ inputs, ... }:
let
  mkConfig =
    moduleSystem:
    inputs.denix.lib.configurations {
      inherit moduleSystem;
      homeManagerUser = "arca";

      paths = [
        ../../hosts
        ../../modules
      ];

      extensions = with inputs.denix.lib.extensions; [
        args
        overlays
        (base.withConfig {
          args.enable = true;
          hosts.features = {
            features = [
              "cli"
              "gui"
              "wifi"
              "bluetooth"
              "secureboot"
              "fingerprint"
              "xremap"
            ];
            defaultByHostType = {
              desktop = [
                "cli"
                "gui"
              ];
              laptop = [
                "cli"
                "gui"
                "wifi"
                "bluetooth"
              ];
            };
          };
        })
      ];

      specialArgs = {
        inherit inputs;
      };
    };
in
{
  flake = {
    nixosConfigurations = mkConfig "nixos";
    darwinConfigurations = mkConfig "darwin";
    homeConfigurations = mkConfig "home";
  };
}
