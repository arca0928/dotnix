{ delib, host, ... }:
delib.module {
  name = "programs.pi";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.pi-coding-agent.enable = true;
  };
}
