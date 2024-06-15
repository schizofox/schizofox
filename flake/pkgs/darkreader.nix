{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}: let
  version = "4.9.86";
in
  buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      rev = "v${version}";
      hash = "sha256-i5/zlDunCzqGAf6VtgGk/hUKQeavcxbxSZuaOvDaMiw=";
    };

    npmDepsHash = "sha256-0Rl3ceRywaGFNo+OF55vSlTbI2II//w//YIK0I5+b5o=";

    patchPhase = ''
      runHook prePatch

      substituteInPlace src/defaults.ts --replace "181a1b" ${background}
      substituteInPlace src/defaults.ts --replace "e8e6e3" ${foreground}

      runHook postPatch
    '';

    npmBuildFlags = ["--" "--firefox"];

    installPhase = ''
      runHook preInstall
      cp -rv build $out/
      runHook postInstall
    '';

    meta = {
      description = "Custom patched Dark reader for Schizofox";
      maintainers = with lib.maintainers; [notashelf sioodmy];
      license = lib.licenses.mit;
    };
  }
