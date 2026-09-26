{
  lib,
  stdenv,
  rustPlatform,
  versionCheckHook,
  mold,
}: let
  cargoToml = lib.importTOML ./source/Cargo.toml;
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = cargoToml.package.name;
    inherit (cargoToml.package) version;
    __structuredAttrs = true;

    src = let
      fs = lib.fileset;
      s = ./source;
    in
      fs.toSource {
        root = s;
        fileset = fs.unions [
          (s + /Cargo.lock)
          (s + /Cargo.toml)
          (s + /src)
        ];
      };

    cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

    doInstallCheck = true;
    nativeInstallCheckInputs = [versionCheckHook];

    env = lib.optionalAttrs (stdenv.isLinux && !stdenv.hostPlatform.isAarch) {
      CARGO_LINKER = "clang";
      CARGO_RUSTFLAGS = "-Clink-arg=-fuse-ld=${mold}/bin/mold";
    };

    meta = {
      description = "Searx(ng) instance randomizer for Schizofox";
      homepage = "https://github.com/schizofox/searx-randomizer";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [NotAShelf];
      mainProgram = "searx-randomizer";
    };
  })
