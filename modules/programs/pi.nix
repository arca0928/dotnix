{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.pi";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    pi-coding-agent
  ];
}
