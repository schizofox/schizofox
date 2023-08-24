{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}:
buildNpmPackage rec {
  pname = "darkreader";
  version = "4.9.65";

  src = fetchFromGitHub {
    owner = "darkreader";
    repo = "darkreader";
    rev = "v${version}";
    hash = "sha256-VvhVtaZ4A3l1W+yJeqVhjBzCNGvcDbhkWJzTaPmONvA=";
  };
  npmDepsHash = "sha256-va92uYgdyGtVYGRI7dACRRcLMd5KAVZAGkcR3ul7i7s=";

  patchPhase = ''
    runHook prePatch
    sed -i 's/181a1b/${background}/g' src/defaults.ts
    sed -i 's/e8e6e3/${foreground}/g' src/defaults.ts
    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    cp -r build $out/
    runHook postInstall
  '';

  meta = with lib; {
    maintainers = with maintainers; [notashelf];
  };
}
