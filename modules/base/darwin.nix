{
  flake.modules.darwin.base = {
    system = {
      primaryUser = "arca";
    };
    security.pam.services.sudo_local = {
      touchIdAuth = true;
      reattach = true;
    };
  };
}
