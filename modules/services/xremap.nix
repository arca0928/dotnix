{
  delib,
  host,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "services.xremap";

  options = delib.singleEnableOption host.xremapFeatured;
  nixos.always = {
    imports = [ inputs.xremap.nixosModules.default ];
    services.xremap.enable = lib.mkDefault false;
  };
  nixos.ifEnabled = {
    services.xremap = {
      enable = true;

      config = {
        modmap = [
          {
            remap = {
              "CapsLock" = "Ctrl_L";
            };
          }
        ];
        keymap = [
          {
            name = "Onishi";
            device = {
              only = "AT Translated Set 2 keyboard";
            };
            remap = {
              "MINUS" = "SLASH";
              "Q" = "Q";
              "W" = "L";
              "E" = "U";
              "R" = "COMMA";
              "T" = "DOT";
              "Y" = "F";
              "U" = "W";
              "I" = "R";
              "O" = "Y";
              "P" = "P";
              "A" = "E";
              "S" = "I";
              "D" = "A";
              "F" = "O";
              "G" = "MINUS";
              "H" = "K";
              "J" = "T";
              "K" = "N";
              "L" = "S";
              "SEMICOLON" = "H";
              "Z" = "Z";
              "X" = "X";
              "C" = "C";
              "V" = "V";
              "B" = "SEMICOLON";
              "N" = "G";
              "M" = "D";
              "COMMA" = "M";
              "DOT" = "J";
              "SLASH" = "B";
            };
            mode = [
              "ONISHI"
            ];
          }
        ];
        default_mode = "ONISHI";
      };
    };
  };
}
