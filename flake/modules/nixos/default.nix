self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasInfix;
  common = import ../common/files.nix {
    inherit
      config
      lib
      pkgs
      self
      profilesPath
      cursorTheme
      iconTheme
      gtkTheme
      ;
  };

  cfg = config.programs.schizofox;

  mozillaConfigPath =
    if isDarwin then "Library/Application Support/Mozilla" else "/home/${cfg.userName}/.mozilla";

  firefoxConfigPath =
    if isDarwin then "Library/Application Support/Firefox" else mozillaConfigPath + "/firefox";

  profilesPath = if isDarwin then "${firefoxConfigPath}/Profiles" else firefoxConfigPath;

  maybeTheme =
    opt:
    lib.findFirst builtins.isNull opt.package [
      opt
      opt.package
    ];

  gtkTheme = null; # maybeTheme config.gtk.theme;

  iconTheme = null; # maybeTheme config.gtk.iconTheme;

  cursorTheme = null; # maybeTheme config.home.pointerCursor;

  defaultProfile = "${profilesPath}/schizo.default";

  firefoxConfigDerivation = pkgs.stdenv.mkDerivation {
    name = "schizofox-config";

    passAsFile = [
      "fileProfiles"
      "fileUserChrome"
      "fileUserContent"
      "fileUser"
    ];
    fileProfiles = common.files."profiles.ini".text;
    fileUserChrome = common.files."userChrome.css".text;
    fileUserContent = common.files."userContent.css".text;
    fileUser = common.files."user.js".text;

    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp "$fileProfilesPath" "$out/profiles.ini"
      cp "$fileUserChromePath" "$out/userChrome.css"
      cp "$fileUserContentPath" "$out/userContent.css"
      cp "$fileUserPath" "$out/user.js"
    '';
  };
in
{
  meta.maintainers = with lib.maintainers; [
    sioodmy
    NotAShelf
  ];
  imports = [
    ../common/options
    ./option.nix
  ];
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasInfix "esr" cfg.package.version;
        message = ''
          The package provided to 'programs.schizofox.package' is not an ESR release of Firefox: ${cfg.package.pname}

          For policies to function as intended, you must an ESR release of Firefox. If you think this is a mistake, please open an issue.
        '';
      }
      {
        assertion = cfg.userName != "";
        message = ''
          Target user configured in 'programs.schizofox.userName' must be defined when using the nixosModule version of Schizofox
        '';
      }
    ];

    # Use activation script to create symlinks
    system.userActivationScripts.schizofox.text = ''
      # Create target directories if they don't exist
      for dir in "${firefoxConfigPath}" "${defaultProfile}/chrome"; do
        mkdir -p "$dir"
      done

      ln -sfn "${firefoxConfigDerivation}/profiles.ini" "${firefoxConfigPath}/profiles.ini"
      ln -sfn "${firefoxConfigDerivation}/userChrome.css" "${defaultProfile}/chrome/userChrome.css"
      ln -sfn "${firefoxConfigDerivation}/userContent.css" "${defaultProfile}/chrome/userContent.css"
      ln -sfn "${firefoxConfigDerivation}/user.js" "${defaultProfile}/user.js"
      ${pkgs.nix}/bin/nix-store --add-root "${firefoxConfigPath}/gcroot" --realise "${firefoxConfigDerivation}"
    '';

    environment.systemPackages = common.packages;

    # Start a local Systemd service for responding to requests with a random
    # Searxng instance to handle the request. Searxng instances will be selected
    # from the list of instances passed to `search.searxRandomizer.instances`
    systemd.user.units.searx-randomizer = mkIf cfg.search.searxRandomizer.enable common.searx-randomizer-unit;
  };
}
