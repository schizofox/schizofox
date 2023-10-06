{
  stdenvNoCC,
  backgroundDarker ? "19171a",
  background ? "201e21",
  font ? "Lato",
  border ? "rgba(0, 0, 0, 0)",
  ...
}: let
  version = "0.1.0";
  pname = "simplefox-userChrome";
in
  stdenvNoCC.mkDerivation {
    inherit version pname;

    src = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/migueravila/SimpleFox/master/chrome/userChrome.css";
      sha256 = "0jqv1fc1h1a2whgxa8rrq58znfaplrwhpkh5vrcja6hwbix1j1dh";
    };

    unpackPhase = ''
      cp $src userChrome.css
    '';
    dontBuild = true;
    dontConfigure = true;

    patches = [
      ./patches/0001-add-font-config.patch
    ];

    postPatch = ''
      sed -i 's/19171a/${backgroundDarker}/g' userChrome.css
      sed -i 's/201e21/${background}/g' userChrome.css
      sed -i 's/Lato/${font}/g' userChrome.css
      # TODO: fonts
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -vr userChrome.css $out
      ls $out
      runHook postInstall
    '';
  }
