{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.partitions
      ];

      partitionedAttrs = {
        apps = "emacs";
        devShells = "dev";
        formatter = "dev";
        packages = "emacs";
        nixosConfigurations = "denix";
        homeConfigurations = "denix";
      };
      partitions = {
        dev = {
          extraInputsFlake = ./partitions/dev;
          module = ./partitions/dev/flake-module.nix;
        };

        emacs = {
          extraInputsFlake = ./partitions/emacs;
          module = ./partitions/emacs/flake-module.nix;
        };

        denix = {
          extraInputsFlake = ./partitions/denix;
          module = ./partitions/denix/flake-module.nix;
        };
      };

      systems = [ "x86_64-linux" ];

    };
}
