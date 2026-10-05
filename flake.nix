{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-darwin.follows = "nix-darwin";
    };

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
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    twist.url = "github:emacs-twist/twist.nix";
    org-babel.url = "github:emacs-twist/org-babel";
    lsp-proxy = {
      url = "github:jadestrong/lsp-proxy";
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

    mangowc = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    shojiwm = {
      url = "github:bea4dev/ShojiWM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wezterm/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ewm = {
      url = "git+https://codeberg.org/ezemtsov/ewm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-config = {
      url = "github:arca0928/emacs-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.emacs-overlay.follows = "emacs-overlay";
      inputs.org-babel.follows = "org-babel";
      inputs.twist.follows = "twist";
      inputs.lsp-proxy.follows = "lsp-proxy";
    };
  };

  outputs =
    inputs:
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
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt.flakeModule
        inputs.git-hooks.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      flake = {
        nixosConfigurations = mkConfig "nixos";
        homeConfigurations = mkConfig "home";
        darwinConfigurations = mkConfig "darwin";
      };

      perSystem =
        {
          pkgs,
          config,
          system,
          ...
        }:
        let
          emacs = inputs.emacs-config.packages.${system}.default;
          ewm = pkgs.callPackage "${inputs.ewm}/nix/default.nix" {
            emacsPackage = emacs.emacs;
          };
          ewmLoadPath = pkgs.writeText "ewm-load-path.el" (
            ";;; -*- lexical-binding: t -*-\n"
            + pkgs.lib.concatMapStrings (pkg: ''
              (add-to-list 'load-path "${pkg}/share/emacs/site-lisp")
            '') ([ ewm ] ++ ewm.packageRequires)
          );
        in
        {
          packages = {
            my-emacs =
              if pkgs.stdenv.hostPlatform.isLinux then
                emacs.overrideScope (
                  _final: prev: {
                    # Keep EWM's Lisp and native module available to the external launcher.
                    emacsWrapper = pkgs.symlinkJoin {
                      name = "emacs-with-ewm";
                      paths = [ prev.emacsWrapper ];
                      nativeBuildInputs = [ pkgs.makeWrapper ];
                      postBuild = ''
                        wrapProgram $out/bin/emacs \
                          --add-flags "--load ${ewmLoadPath}"
                      '';
                      passthru = {
                        inherit (prev.emacsWrapper) elispManifestPath;
                      };
                      meta.mainProgram = "emacs";
                    };
                  }
                )
              else
                emacs;
          }
          // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux { inherit ewm; };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nixd
            ];
            shellHook = ''
              ${config.pre-commit.shellHook}
            '';
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
          };

          pre-commit = {
            check.enable = true;
            settings.hooks.treefmt.enable = true;
          };
        };
    };
}
