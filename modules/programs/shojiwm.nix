{
  delib,
  host,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "programs.shojiwm";

  options = delib.singleEnableOption host.guiFeatured;

  nixos.always.imports = [
    inputs.shojiwm.nixosModules.default
  ];

  nixos.ifEnabled = {
    programs.shojiwm = {
      enable = true;
    };

    environment.systemPackages = [
      pkgs.apple-cursor
    ];
  };
}
