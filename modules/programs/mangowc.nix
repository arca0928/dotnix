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

  nixos.ifEnabled.programs.mango.enable = true;

  home.always.imports = [
    inputs.mangowc.hmModules.mango
  ];

  home.ifEnabled.wayland.windowManager.mango = {
    enable = true;

    settings = {
      bind = [
        "SUPER,r,reload_config"
        "SUPER,q,spawn,ghostty"
        "SUPER,m,quit"
        "SUPER,b,spawn,zen-beta"
      ];
    };
  };
}
