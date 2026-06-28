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

      profile = {
        lockDir = ./lock;
        initFiles = [ (pkgs.tangleOrgBabelFile "init.el" ./init.org { }) ];
        initParser = inputs.twist.lib.parseSetup { inherit (inputs.nixpkgs) lib; } { };
        extraPackages = [
          "setup"
        ];
        emacsPackage = pkgs.emacs-git-pgtk;
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
      packages.my-emacs = package;
      apps = package.makeApps { lockDirName = "partitions/emacs/lock"; };
    };
}
