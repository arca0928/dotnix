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
        emacsPackage = pkgs.emacs-git-pgtk;
        extraRecipeDir = ./recipes;
      };

      package = (
        inputs.twist.lib.makeEnv {
          inherit pkgs;
          inherit (profile) emacsPackage lockDir initFiles;
          registries = [
            {
              name = "recipes";
              type = "melpa";
              path = profile.extraRecipeDir;
            }
          ];
        }
      );
    in
    {
      packages.my-emacs = package;
    };
}
