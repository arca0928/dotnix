{ delib, host, ... }:
delib.module {
  name = "programs.git";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled =
    { myconfig, ... }:
    let
      inherit (myconfig.constants) userGitName userGitEmail;
    in
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = userGitName;
            email = userGitEmail;
          };
          init.defaultBranch = "main";
        };
      };
    };
}
