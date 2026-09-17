# SPDX-License-Identifier: EUPL-1.2
# tack-managed resolver. delete this line to take ownership; tack will leave it alone afterwards.

let
  inherit (builtins)
    attrNames
    attrValues
    concatMap
    elem
    elemAt
    filter
    fromJSON
    head
    intersectAttrs
    isList
    isString
    listToAttrs
    mapAttrs
    match
    pathExists
    readFile
    substring
    tail
    trace
    ;

  pins = fromTOML (readFile ./pins.toml);
  lock = fromJSON (readFile ./pins.lock.json);
  declared = pins.inputs or { };
  all_follow_raw = pins.all_follow or { };

  # flatten `target = [aliases]` rows alongside `alias = "target"` rows
  all_follow = listToAttrs (
    concatMap (
      key:
      let
        val = all_follow_raw.${key};
      in
      if isList val then
        [
          {
            name = key;
            value = key;
          }
        ]
        ++ map (a: {
          name = a;
          value = key;
        }) val
      else if isString val then
        [
          {
            name = key;
            value = val;
          }
        ]
      else
        [ ]
    ) (attrNames all_follow_raw)
  );

  knownTypes = [
    "github"
    "gitlab"
    "git"
    "tarball"
    "path"
    "indirect"
  ];

  call =
    {
      overrides ? { },
    }:
    let
      # path nodes are convenience pins, so return the live local path directly
      # because fetchTree rejects unlocked paths in pure eval
      fetchPin =
        name:
        if !(lock ? ${name}) then
          throw "tack: pin '${name}' has no lock entry; run tack update"
        else
          let
            node = lock.${name};
          in
          if (node.type or "") == "path" then
            {
              outPath = if substring 0 1 node.path == "/" then node.path else ./. + ("/" + node.path);
              lastModified = node.lastModified or 0;
            }
            // (if node ? narHash then { inherit (node) narHash; } else { })
          else if !(elem (node.type or "") knownTypes) then
            throw "tack: unknown lock type '${node.type or "?"}' for pin '${name}'"
          else
            fetchTree node;

      fetchFixed =
        { name, entry }:
        let
          raw = derivation {
            inherit name;
            inherit (entry) url;
            builder = "builtin:fetchurl";
            system = "builtin";
            outputHash = entry.sha256;
            outputHashAlgo = "sha256";
            outputHashMode = "flat";
          };
          unpacked = derivation {
            inherit name;
            builder = "builtin:unpack-channel";
            system = "builtin";
            src = raw;
            channelName = name;
          };
        in
        if (entry.unpack or "file") == "tarball" then unpacked.outPath + "/" + name else raw.outPath;

      resolveSpec =
        { upLock, spec }:
        if isList spec then
          walkPath {
            inherit upLock;
            nodeName = upLock.root;
            path = spec;
          }
        else
          spec;

      walkPath =
        {
          upLock,
          nodeName,
          path,
        }:
        if path == [ ] then
          nodeName
        else if !(upLock.nodes ? ${nodeName}) then
          throw "tack: follows path dead-end: no node '${nodeName}' in flake.lock"
        else
          let
            key = head path;
            inputs = upLock.nodes.${nodeName}.inputs or { };
          in
          if !(inputs ? ${key}) then
            throw "tack: follows path dead-end: node '${nodeName}' has no input '${key}'"
          else
            walkPath {
              inherit upLock;
              nodeName = resolveSpec {
                inherit upLock;
                spec = inputs.${key};
              };
              path = tail path;
            };

      followsFor =
        pin:
        let
          rules = removeAttrs all_follow (pin.exclude_follow or [ ]);
        in
        {
          level = rules // (pin.follows or { });
          deep = rules;
        };

      resolveFollows = mapAttrs (
        _: target: self.${target} or (throw "tack: follows target '${target}' is not a pin")
      );

      # follows key is `flake:name`, `tack:name`, or bare `name`
      # project onto one side, rekeyed to bare names
      followsForSide =
        { side, follows }:
        listToAttrs (
          concatMap (
            key:
            let
              m = match "(flake|tack):(.*)" key;
            in
            if m == null then
              [
                {
                  name = key;
                  value = follows.${key};
                }
              ]
            else if head m == side then
              [
                {
                  name = elemAt m 1;
                  value = follows.${key};
                }
              ]
            else
              [ ]
          ) (attrNames follows)
        );

      mkCallerInputs =
        {
          upLock,
          nodeName,
          rawInputs,
          levelFollows,
          deepFollows,
        }:
        let
          resolved = resolveFollows levelFollows;
        in
        mapAttrs (
          n: _decl:
          resolved.${n} or (
            if upLock != null then
              let
                ref =
                  (upLock.nodes.${nodeName}.inputs or { }).${n}
                    or (throw "tack: input '${n}' declared but not in flake.lock node '${nodeName}'");
                childName = resolveSpec {
                  inherit upLock;
                  spec = ref;
                };
                childNode = upLock.nodes.${childName};
                childSrc = fetchTree childNode.locked;
              in
              if childNode.flake or true then
                evalTransitive {
                  inherit upLock;
                  nodeName = childName;
                  sourceInfo = childSrc;
                  follows = deepFollows;
                }
              else
                childSrc
            else
              throw "tack: no flake.lock; cannot resolve input '${n}'"
          )
        ) rawInputs;

      mkFlakeResult =
        {
          sourceInfo,
          flakeDir,
          callerInputs,
          outputs,
        }:
        outputs
        // sourceInfo
        // {
          outPath = flakeDir;
          inputs = callerInputs;
          inherit outputs sourceInfo;
          _type = "flake";
        };

      evalFlake =
        {
          sourceInfo,
          flakeDir,
          upLock,
          nodeName,
          levelFollows,
          deepFollows,
        }:
        let
          raw = import (flakeDir + "/flake.nix");

          tackPinsPath = flakeDir + "/.tack/pins.toml";
          hasTack = pathExists tackPinsPath;
          upPins = if hasTack then fromTOML (readFile tackPinsPath) else { };

          # project follows onto each side, keep only names that side has
          # bare follow reaches both; `flake:`/`tack:` reaches just one
          tackOverrides = resolveFollows (
            intersectAttrs (upPins.inputs or { }) (followsForSide {
              side = "tack";
              follows = levelFollows;
            })
          );
          flakeLevel = intersectAttrs (raw.inputs or { }) (followsForSide {
            side = "flake";
            follows = levelFollows;
          });

          # deep follows pass down raw, so each descendant re-projects per side
          callerInputs = mkCallerInputs {
            inherit upLock nodeName deepFollows;
            rawInputs = raw.inputs or { };
            levelFollows = flakeLevel;
          };

          # upstream declares its outputs forward tackOverrides; a closed `{ self }:`
          # would throw on the extra kwarg, so forward only when declared
          supportsOverrides = (upPins.tack or { }).recomposable or false;

          extraArgs = if supportsOverrides && tackOverrides != { } then { inherit tackOverrides; } else { };

          outputs = raw.outputs (callerInputs // extraArgs // { self = result; });

          result =
            let
              base = mkFlakeResult {
                inherit
                  sourceInfo
                  flakeDir
                  callerInputs
                  outputs
                  ;
              };
            in
            if hasTack && tackOverrides != { } && !supportsOverrides then
              trace "tack: ${flakeDir}: not marked recomposable (set [tack] recomposable = true); overrides will not reach upstream" base
            else
              base;
        in
        result;

      evalTransitive =
        {
          upLock,
          nodeName,
          sourceInfo,
          follows,
        }:
        evalFlake {
          inherit upLock nodeName sourceInfo;
          flakeDir = sourceInfo.outPath;
          levelFollows = follows;
          deepFollows = follows;
        };

      evalTopFlake =
        { sourceInfo, pin }:
        let
          flakeDir = sourceInfo.outPath + (if pin ? dir then "/" + pin.dir else "");
          upLockPath = flakeDir + "/flake.lock";
          upLock = if pathExists upLockPath then fromJSON (readFile upLockPath) else null;
          rootNode = if upLock != null then upLock.root else null;
          f = followsFor pin;
        in
        evalFlake {
          inherit sourceInfo flakeDir upLock;
          nodeName = rootNode;
          levelFollows = f.level;
          deepFollows = f.deep;
        };

      evalFetch =
        {
          sourceInfo,
          pin,
          subdir,
        }:
        let
          path = sourceInfo.outPath + subdir;
          tackPinsPath = path + "/.tack/pins.toml";
          hasTack = pathExists tackPinsPath;
          upPins = if hasTack then fromTOML (readFile tackPinsPath) else { };
          f = followsFor pin;
          # a fetch drill-in is tack-only
          tackOverrides = resolveFollows (
            intersectAttrs (upPins.inputs or { }) (followsForSide {
              side = "tack";
              follows = f.level;
            })
          );
        in
        # only override tack files within a `fetch`, since there's no flake.lock
        if hasTack && tackOverrides != { } then
          let
            upstream = import (path + "/.tack");
          in
          # old resolvers return a plain attrset, not a callable functor
          if upstream ? __functor then
            (upstream { overrides = tackOverrides; }) // { outPath = path; }
          else
            trace "tack: ${path}: upstream .tack predates override support; overrides will not reach it" path
        else
          path;

      loadPin =
        { name, pin }:
        let
          pinType = pin.type or (if pin.flake or true then "flake" else "fetch");
        in
        if pinType == "fixed" then
          fetchFixed {
            inherit name;
            entry = lock.${name};
          }
        else
          let
            sourceInfo = fetchPin name;
            subdir = if pin ? dir then "/" + pin.dir else "";
          in
          if pinType == "flake" then
            evalTopFlake { inherit sourceInfo pin; }
          else
            evalFetch { inherit sourceInfo pin subdir; };

      # undeclared lock entries are synthesised into toplevels by auto-dedup
      # only when referenced as [all_follow] targets
      autoTargets = listToAttrs (
        map (target: {
          name = target;
          value = true;
        }) (attrValues all_follow)
      );
      autoNames = filter (n: !(declared ? ${n}) && autoTargets ? ${n}) (attrNames lock);
      autoPin =
        name:
        let
          sourceInfo = fetchPin name;
        in
        if pathExists (sourceInfo.outPath + "/flake.nix") then
          evalTopFlake {
            inherit sourceInfo;
            pin = { };
          }
        else
          sourceInfo;

      self =
        (mapAttrs (name: pin: loadPin { inherit name pin; }) declared)
        // listToAttrs (
          map (name: {
            inherit name;
            value = autoPin name;
          }) autoNames
        )
        // overrides;
    in
    self // { __functor = _: call; };
in
call { }
