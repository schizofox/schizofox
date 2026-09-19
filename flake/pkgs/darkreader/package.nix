{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "darkreader";
  version = "4.9.132";
  extid = "addon@darkreader.org";

  nodejs = nodejs_22;

  src = fetchFromGitHub {
    owner = "darkreader";
    repo = "darkreader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1GNqwA4RfZ2jTm8FkIk5kSOBj7IWTiICFGLKs0My1G0=";
  };

  patches = [./no-news.patch];

  npmDepsHash = "sha256-eyVjBcaDUtoVSAnOWDhGFHeM1JoPXRyuyZp6lO5kB5E=";

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
    # Make the output look like it was created with fetchFirefoxAddon.
    cp -v $out/release/darkreader-firefox.xpi $out/${finalAttrs.extid}.xpi
    runHook postInstall
  '';

  meta = {
    description = "Custom build of Darkreader for Schizofox, with color tweaks.";
    maintainers = with lib.maintainers; [NotAShelf alfarel];
    license = lib.licenses.mit;
  };
})
