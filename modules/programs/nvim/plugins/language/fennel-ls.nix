{ delib, pkgs, ... }:
let
  nvimDocset = pkgs.fetchurl {
    url = "https://git.sr.ht/~micampe/fennel-ls-nvim-docs/blob/a072d3f5d2dd98cf0411cd16446a0f3c96ee7938/nvim.lua";
    hash = "sha256-ef9lDSKhECCE+GWqqxRsv43AtzoGzU67CCMed3EoS4A=";
  };
in
delib.module {
  name = "programs.nixvim";

  home.ifEnabled = {
    xdg.configFile."nvim/flsproject.fnl".text = ''
      {:lua-version :lua5.1
       :libraries {:nvim true}}
    '';

    xdg.dataFile."fennel-ls/docsets/nvim.lua".source = nvimDocset;
  };
}
