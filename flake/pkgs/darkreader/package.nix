{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}: let
  version = "4.9.125";
in
  buildNpmPackage {
    pname = "darkreader";
    inherit version;

    nodejs = nodejs_22;

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      tag = "v${version}";
      hash = "sha256-CpDSKiN1291up8BxDAD1E5+wrpuCzEpL5+KQUa5JnjA=";
    };

    patches = [./no-news.patch];

    npmDepsHash = "sha256-ld1hyhyssbG8cI5Kxe5oRECbkFx6hNcoSprIQUf9GAM=";

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
      description = "Custom build of Darkreader for Schizofox, with color tweaks.";
      maintainers = with lib.maintainers; [notashelf sioodmy alfarel];
      license = lib.licenses.mit;
    };
  }
