{ delib, ... }:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.plugins = {
    neotab = {
      enable = true;

      settings = {
        tabkey = "<C-CR>";
        reverse_key = "";

        act_as_tab = false;

        behavior = "nested";

        pairs = [
          {
            open = "(";
            close = ")";
          }
          {
            open = "[";
            close = "]";
          }
          {
            open = "{";
            close = "}";
          }
          {
            open = "'";
            close = "'";
          }
          {
            open = "\"";
            close = "\"";
          }
          {
            open = "`";
            close = "`";
          }
          {
            open = "<";
            close = ">";
          }
        ];
      };
    };
  };
}
