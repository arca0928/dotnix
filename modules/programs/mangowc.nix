{
  delib,
  host,
  inputs,
  ...
}:
delib.module {
  name = "programs.mango";
  options = delib.singleEnableOption host.guiFeatured;

  nixos.always.imports = [
    inputs.mangowc.nixosModules.mango
  ];
}
