{
  flake.modules.nixos.base = {
    boot = {
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
