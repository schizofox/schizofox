{
  stdenvNoCC,
  backgroundDarker ? "19171a",
  background ? "201e21",
  font ? "Lato",
  border ? "rgba(0, 0, 0, 0)",
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "simplefox-userChrome";
  version = "0.1.0";

  src = ./src/userChrome.css;

  unpackPhase = ''
    cp -v $src userChrome.css
    chmod +w userChrome.css
  '';

  dontBuild = true;
  dontConfigure = true;

  postPatch = ''
    sed -i "s/19171a/${backgroundDarker}/g" userChrome.css
    sed -i "s/201e21/${background}/g" userChrome.css
    sed -i "s/rgba(0, 0, 0, 0)/#${border}/g" userChrome.css
    sed -i "s/Lato/${font}/g" userChrome.css
    printf '\n* { font-family: "${font}" !important; }' >> userChrome.css
  '';

  installPhase = ''
    runHook preInstall
    cp -v userChrome.css $out
    runHook postInstall
  '';
}
