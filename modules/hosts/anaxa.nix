{config, ...}:
let
  flakeModules = config.flake.modules;
in
{
  flake.modules.darwin."hosts/anaxa" = {
    ...
  }: {
    imports = 
      with flakeModules.darwin;
      [
        base
        tailscale
      ]
      ++ [
        {
          home-manager.users.arca.imports =
            with flakeModules.darwin; [
            base
            terminal
            browser
            nixvim
            tuiApps
            dots
          ];
        }
      ]
  }
}