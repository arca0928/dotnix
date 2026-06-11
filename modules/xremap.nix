{
  flake.modules.nixos.xremap =
    { inputs, ... }:
    {
      imports = [
        inputs.xremap.nixosModules.default
      ];

      services.xremap = {
        enable = true;

        config = {
          virtual_modifiers = [
            "F24"
          ];
          modmap = [
            {
              remap = {
                "CapsLock" = "Ctrl_L";
              };
            }
          ];
          keymap = [
            {
              remap = {
                "LeftMeta-Shift_L-F23" = "F24";
              };
            }
            {
              name = "Switch mode";
              remap = {
                "F24-1" = {
                  set_mode = "ONISHI";
                };
                "F24-2" = {
                  set_mode = "default";
                };
              };
            }
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
