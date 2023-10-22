{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}: let
  version = "4.9.67";
in
  buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      rev = "v${version}";
      hash = "sha256-lz7wkUo4OB/Gu/q45RVpj9Vmk4u65D0opvjgOeEjjpw=";
    };

    npmDepsHash = "sha256-DgijQj3p4yiAUlwUC1cXkF8afHdm2ZOd/PNXVt6WZW8=";

    patchPhase = ''
      runHook prePatch
      sed -i 's/181a1b/${background}/g; s/e8e6e3/${foreground}/g' src/defaults.ts
      runHook postPatch
    '';

    npmBuildFlags = ["--" "--firefox"];

    installPhase = ''
      runHook preInstall
      cp -r build $out/
      runHook postInstall
    '';

    meta = with lib; {
      maintainers = with maintainers; [notashelf];
    };
  }
