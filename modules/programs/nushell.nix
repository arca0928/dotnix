{
  delib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nushell";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.nushell = {
      enable = true;
      plugins = with pkgs; [
        nushellPlugins.formats
      ];

      configFile.source = ../../dots/nushell/config.nu;
    };

    home.shell.enableNushellIntegration = true;
    programs.zoxide.enableNushellIntegration = true;
  };
}
