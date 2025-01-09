{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  esbuild,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}: let
  version = "4.9.99";
in
  buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      tag = "v${version}";
      hash = "sha256-K375/4qOyE1Tp/T5V5uCGcNd1IVVbT1Pjdnq/8oRHj0=";
    };

    patches = [./no-news.patch];

    # This is horrible. Since we do not have a binary cache users will
    # have to build Esbuild from scratch each time. Unfortunately for
    # them and for us, nixpkgs' esbuild is not compatible with darkreader's.
    # Hopefully temporary workaround.
    env.ESBUILD_BINARY_PATH = lib.getExe (esbuild.overrideAttrs (
      final: _: {
        version = "0.24.0";
        src = fetchFromGitHub {
          owner = "evanw";
          repo = "esbuild";
          rev = "v${final.version}";
          hash = "sha256-czQJqLz6rRgyh9usuhDTmgwMC6oL5UzpwNFQ3PKpKck=";
        };
        vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
      }
    ));
    npmDepsHash = "sha256-m41HkwgbeRRmxJALQFJl/grYjjIqFOc47ltaesob1FA=";

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
      maintainers = with lib.maintainers; [notashelf sioodmy];
      license = lib.licenses.mit;
    };
  }
