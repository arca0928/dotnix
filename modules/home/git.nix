{
  flake.modules.homeManager.base = {
    programs.git = {
      enable = true;
      settings = {
        user.name = "arca0928";
        user.email = "arca0928@gmail.com";
        init.defaultBranch = "main";
      };
    };
  };
}

