{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  esbuild,
  nodejs_20,
  background ? "1e1e2e",
  foreground ? "cdd6f4",
  ...
}: let
  # The next version, 4.9.112, from October 15th 2025,
  # adds a dependency that fails since it isn't cached for some reason.
  # On x86_64-linux, is "@unrs/resolver-binding-linux-x64-gnu" v1.11.1.
  version = "4.9.110";
in
  buildNpmPackage {
    pname = "darkreader";
    inherit version;

    # 24 fails because of missing dependencies from esbuild.
    nodejs = nodejs_20;

    src = fetchFromGitHub {
      owner = "darkreader";
      repo = "darkreader";
      tag = "v${version}";
      hash = "sha256-mT29w1j8G3/OAI5mXz3+3HWpqCcqtGgVR7SKW/tf/qM=";
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
    npmDepsHash = "sha256-IrRq/ErXTeHWiWN7iui5XJVZjjR0vjgfcsgUtmgjmvs=";

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
