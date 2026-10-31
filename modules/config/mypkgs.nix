{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "mypkgs";

  myconfig.always = {
    args.shared.mypkgs = import ../../mypkgs {
      inherit pkgs inputs;
    };
  };
}
