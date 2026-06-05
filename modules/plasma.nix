{
  flake.modules.nixos.plasma =
    { inputs, ... }:
    {
      imports = [
        inputs.silentSDDM.nixosModules.default
      ];
      services.desktopManager.plasma6.enable = true;
    };
}
