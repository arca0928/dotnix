{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "programs.nixvim";

  home.ifEnabled.programs.nixvim.nixpkgs.overlays = lib.optionals (host.name == "khaslana") [
    (_final: prev: {
      biome = prev.biome.overrideAttrs (old: {
        env = (old.env or { }) // {
          CARGO_PROFILE_RELEASE_LTO = "thin";
          CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "16";
          RUST_TEST_THREADS = "1";
        };
        preBuild = ''
          ulimit -v ${toString (16 * 1024 * 1024)}
        ''
        + (old.preBuild or "");
      });
    })
  ];
}
