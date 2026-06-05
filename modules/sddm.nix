{
  flake.modules.nixos.sddm =
    {
      inputs,
      ...
    }:
    {
      imports = [ inputs.silentSDDM.nixosModules.default ];
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings.General.DisplayServer = "wayland";
      };
      programs.silentSDDM = {
        enable = true;
        theme = "silvia";
      };
    };
}
