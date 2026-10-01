{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.emacs-overlay.overlay
          inputs.org-babel.overlays.default
        ];
      };

      # Use EWM's Nix build for both the Lisp files and the Rust module.
      ewm = pkgs.callPackage "${inputs.ewm}/nix/default.nix" {
        emacsPackage = profile.emacsPackage;
      };

      profile = {
        lockDir = ./lock;
        initFiles = [ (pkgs.tangleOrgBabelFile "init.el" ./init.org { }) ];
        initParser = inputs.twist.lib.parseSetup { inherit (inputs.nixpkgs) lib; } { };
        extraPackages = [
          "setup"
          # Magit needs a newer Transient than the one bundled with Emacs 30.
          "transient"
        ];
        emacsPackage = pkgs.emacs-pgtk;
        extraRecipeDir = ./recipes;
        exportManifest = true;
      };

      package = (
        inputs.twist.lib.makeEnv {
          inherit pkgs;
          inherit (profile)
            emacsPackage
            lockDir
            initFiles
            initParser
            extraPackages
            exportManifest
            ;
          extraSiteStartElisp = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux (
            pkgs.lib.concatMapStrings (pkg: ''
              (add-to-list 'load-path "${pkg}/share/emacs/site-lisp")
            '') ([ ewm ] ++ ewm.packageRequires)
          );
          registries = [
            {
              name = "recipes";
              type = "melpa";
              path = profile.extraRecipeDir;
            }
          ]
          ++ (import ./registries.nix inputs);
        }
      );
    in
    {
      packages = {
        my-emacs = package;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        inherit ewm;
      };
      apps = package.makeApps { lockDirName = "partitions/emacs/lock"; };
    };
}
