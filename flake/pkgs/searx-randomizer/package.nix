{
  lib,
  rustPlatform,
  versionCheckHook,
}: let
  source = ./source;
  cargoToml = lib.importTOML (source + /Cargo.toml);
  src = lib.fileset.toSource {
    root = source;
    fileset = lib.fileset.unions [
      (source + /Cargo.lock)
      (source + /Cargo.toml)
      (source + /src)
    ];
  };
in
  rustPlatform.buildRustPackage {
    pname = cargoToml.package.name;
    inherit (cargoToml.package) version;

    inherit src;
    cargoLock.lockFile = source + /Cargo.lock;

    nativeInstallCheckInputs = [versionCheckHook];
    doInstallCheck = true;

    meta = {
      description = "Searx(ng) instance randomizer for Schizofox";
      homepage = "https://github.com/schizofox/searx-randomizer";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [NotAShelf];
      mainProgram = "searx-randomizer";
    };
  }
