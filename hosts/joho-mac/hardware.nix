{ delib, ... }:
delib.host {
  name = "joho-mac";

  system = "aarch64-darwin";

  home.home.stateVersion = "26.05";
  darwin.system.stateVersion = 7;
}
