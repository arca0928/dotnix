{ inputs, ... }:
{
  flake.modules.homeManager.terminal = { pkgs, ... }: {
    programs.wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
