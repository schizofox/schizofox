{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  background ? "1e1e2e",
  ...
}:
buildNpmPackage {
  pname = "darkreader";
  version = "4.9.65";

  src = fetchFromGitHub {
    owner = "darkreader";
    repo = "darkreader";
    rev = "0b2b1cb26ff1e9ecb564a6d685a7cdba0e9a490c";
    sha256 = "sha256-remwdRSqOf7BCNGmhIlEKtXJHToEGLvnB6732kyAlSw=";
  };
  npmDepsHash = "sha256-va92uYgdyGtVYGRI7dACRRcLMd5KAVZAGkcR3ul7i7s=";

  patchPhase = ''
    runHook prePatch
    sed -i 's/181a1b/${background}/g' src/defaults.ts
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
