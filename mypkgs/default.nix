{
  pkgs,
  inputs,
  ...
}:
{
  dsh = pkgs.callPackage ./dsh/package.nix { };
}
