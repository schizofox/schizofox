{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}: let
  version = "4.9.128";
in
  buildNpmPackage {
    pname = "darkreader";
    inherit version;

    nodejs = nodejs_22;

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      tag = "v${version}";
      hash = "sha256-ZeQsQb4m19mhqmackQYfaqs3Vk2GkIBTefluWU4ALMQ=";
    };

    patches = [./no-news.patch];

    npmDepsHash = "sha256-9aH2gUbbAj6xpPoe2FJ5KYMR4KVDxdD6P8f73soc5Ns=";

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
