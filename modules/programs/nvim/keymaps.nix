{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.keymaps =
    let
      options = {
        noremap = true;
        silent = true;
      };
    in
    [
      {
        key = "<leader>o";
        action = "<CMD>Oil<CR>";
        inherit options;
      }
      {
        key = "k";
        action = "h";
        mode = [
          "n"
          "v"
        ];
        inherit options;
      }
      {
        key = "t";
        action = "j";
        mode = [
          "n"
          "v"
        ];
        inherit options;
      }
      {
        key = "n";
        action = "k";
        mode = [
          "n"
          "v"
        ];
        inherit options;
      }
      {
        key = "s";
        action = "l";
        mode = [
          "n"
          "v"
        ];
        inherit options;
      }
      {
        key = "j";
        action = "n";
        mode = "n";
        inherit options;
      }
      {
        key = "J";
        action = "N";
        mode = "n";
        inherit options;
      }
    ];
}
