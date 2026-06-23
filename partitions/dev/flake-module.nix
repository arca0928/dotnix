{ inputs, ... }:
{
  imports = [
    inputs.treefmt.flakeModule
    inputs.git-hooks.flakeModule
  ];
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nil
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
}
