{ delib, ... }:
delib.module {
  name = "constants";

  options.constants = with delib; {
    username = readOnly (strOption "arca");
    useremail = readOnly (strOption "arca@arca0928.dev");
    userGitEmail = readOnly (strOption "git@arca0928.dev");
    userGitName = readOnly (strOption "arca0928");
  };
}
