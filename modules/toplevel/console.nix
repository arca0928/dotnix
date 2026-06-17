{ delib, ... }:
delib.module {
  name = "console";

  nixos.always = {
    console.useXkbConfig = true;
  };
}
