{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}: let
  version = "4.9.96";
in
  buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      rev = "v${version}";
      hash = "sha256-2AYIFVTTMns1u0jKk3XeFuYdC1MfG9aOCMjAfZtlXuI=";
    };

    npmDepsHash = "sha256-dSuCL8GZXiksqVQ+TypzOdAROn3q30ExaGCJu72GLyY=";

    patchPhase = ''
      runHook prePatch

      substituteInPlace src/defaults.ts \
        --replace-fail "181a1b" ${background} \
        --replace-fail "e8e6e3" ${foreground}

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
