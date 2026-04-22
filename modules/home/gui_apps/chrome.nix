{
  flake.modules.homeManager.chrome =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.google-chrome
      ];
    };
}
