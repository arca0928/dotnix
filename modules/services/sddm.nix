{
  delib,
  host,
  inputs,
  ...
}:
delib.module {
  name = "services.sddm";
  options = delib.singleEnableOption host.guiFeatured;

  nixos.always.imports = [ inputs.silentSDDM.nixosModules.default ];
  nixos.ifEnabled = {
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
