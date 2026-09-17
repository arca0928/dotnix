{ delib, inputs, ... }:
delib.module {
  name = "sops";

  options = delib.singleEnableOption true;

  nixos.always.imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  nixos.ifEnabled = {
    sops.age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };

  darwin.always.imports = [
    inputs.sops-nix.darwinModules.sops
  ];
}
