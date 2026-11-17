{
  lib,
  nodejs-slim_24,
  pnpm_11,
  pnpmConfigHook,

  makeWrapper,

  python3,
  pkg-config,

  bubblewrap,

  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  ...
}:
let
  version = "0.2.2-rc.3";
  srcHash = "sha256-OPKLXuDDcIy7z5qf/WE5REsPOu9KWlAuU3uMs+e89LY=";
  depsHash = "sha256-md84fDBaEnqdQxlsTpaGTkGWWH1dLUGwlSp0EJ+aOA4=";

  pnpm = pnpm_11.override {
    nodejs-slim = nodejs-slim_24;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dsh";
  inherit version;

  src = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "deepseek-harness";
    rev = "dsh-v${version}";
    hash = srcHash;
    leaveDotGit = true;

    postFetch = ''
      git -C "$out" rev-parse HEAD > "$out/.dsh-commit"
      rm -rf "$out/.git"
    '';
  };

  patches = [
    ./fix-internal-api-call.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = depsHash;
  };

  nativeBuildInputs = [
    nodejs-slim_24
    pnpm
    pnpmConfigHook

    makeWrapper

    python3
    pkg-config
  ];

  preBuild = ''
    export DSH_CLIENT_COMMIT_HASH="$(cat .dsh-commit)"
  '';

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dsh
    cp -a . $out/lib/dsh

    mkdir -p $out/bin

    makeWrapper ${lib.getExe nodejs-slim_24} $out/bin/dsh \
      --prefix PATH : ${lib.makeBinPath [ bubblewrap ]} \
      --add-flags "--expose-internals" \
      --add-flags "$out/lib/dsh/apps/cli/lib/bin.js"
      
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.mit;
    mainProgram = "dsh";
  };
})
