{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "nix-darwin";
    };
    systems.url = "github:nix-systems/default";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.partitions
      ];

      partitionedAttrs = {
        devShells = "dev";
        formatter = "dev";
      };
      partitions = {
        dev = {
          extraInputsFlake = ./dev;
          module = ./dev/flake-module.nix;
        };
      };

      flake =
        let
          mkConfig =
            moduleSystem:
            inputs.denix.lib.configurations {
              inherit moduleSystem;
              homeManagerUser = "arca";

              paths = [
                ./hosts
                ./modules
              ];

              extensions = with inputs.denix.lib.extensions; [
                args
                (base.withConfig {
                  args.enable = true;
                  hosts.features = {
                    features = [
                      "cli"
                      "gui"
                      "wifi"
                      "bluetooth"
                      "secureboot"
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
          nixosConfigurations = mkConfig "nixos";
          darwinConfigurations = mkConfig "darwin";
          homeConfigurations = mkConfig "home";
        };

      systems = import inputs.systems;

    };
}
