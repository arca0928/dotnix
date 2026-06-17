{ delib, ... }:
delib.module {
  name = "xkb";

  nixos.always = {
    services.xserver.xkb.layout = "jp";
  };
}
