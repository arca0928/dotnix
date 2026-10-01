{
  delib,
  pkgs,
  inputs,
  config,
  ...
}:
delib.module {
  name = "programs.ewm";
  options = delib.singleEnableOption pkgs.stdenv.hostPlatform.isLinux;

  nixos.always.imports = [
    inputs.ewm.nixosModules.default
  ];

  nixos.ifEnabled = { myconfig, ... }: {
    programs.ewm = {
      enable = true;
      emacsPackage = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.my-emacs;
      package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.ewm;
      ewmPackage = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.ewm;
      extraEmacsArgs = ''--init-directory="$HOME"/${
        pkgs.lib.escapeShellArg
          config.home-manager.users.${myconfig.constants.username}.programs.emacs-twist.directory
      }'';
    };
  };
}
