{ config, ... }:
let
  flakeModules = config.flake.modules;
in
{
  flake.modules.darwin."hosts/anaxa" =
    {
      lib,
      ...
    }:
    {
      imports =
        with flakeModules.darwin;
        [
          base
          tailscale

          arca
        ]
        ++ [
          {
            home-manager.users.arca.imports = with flakeModules.homeManager; [
              base
              terminal
              nixvim
              tuiApps
              shell
              dots
            ];
          }
        ];
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-darwin";
      system.stateVersion = 6;
    };
}

