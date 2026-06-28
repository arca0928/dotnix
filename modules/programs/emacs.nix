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
    home.packages = [
      inputs.lsp-proxy.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    programs.emacs-twist = {
      enable = true;
      config = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.my-emacs;
      createInitFile = true;
      earlyInitFile = pkgs.tangleOrgBabelFile "early-init.el" ../../partitions/emacs/early-init.org { };
      createManifestFile = true;
      emacsclient.enable = true;
      serviceIntegration.enable = true;
    };
  };
}
