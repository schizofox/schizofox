{stdenvNoCC, ...}: let
  version = "0.1.0";
  pname = "simplefox-userContent";
in
  stdenvNoCC.mkDerivation {
    inherit version pname;

    src = ./src/userContent.css;

    dontUnpack = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      cp -vr $src $out
      runHook postInstall
    '';
  }
