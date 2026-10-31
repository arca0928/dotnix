{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.chatgpt-desktop";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    home.packages = [
      pkgs.chatgpt
    ];
  };
}
