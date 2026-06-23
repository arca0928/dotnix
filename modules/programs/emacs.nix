{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "programs.emacs";

  options.programs.emacs = with delib; {
    enable = boolOption true;
    enableServer = boolOption true;
  };

  home.always.imports = [ inputs.twist.homeModules.emacs-twist ];
  home.ifEnabled = {
    programs.emacs-twist = {
      enable = true;
      config = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.my-emacs;
      createInitFile = true;
      createManifestFile = true;
      emacsclient.enable = true;
      serviceIntegration.enable = true;
    };
  };
}
