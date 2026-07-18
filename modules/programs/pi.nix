{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.pi";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled.home.packages = with pkgs; [
    pi-coding-agent
  ];
}
