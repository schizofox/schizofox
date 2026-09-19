let
  inherit (builtins) fromJSON readFile fetchTarball;
  locked = fromJSON (readFile ./flake.lock);

  fetchInput = inputName: let
    node = locked.nodes.${inputName}.locked or (throw "Input '${inputName}' missing from flake.lock");
  in
    if node.type == "github"
    then
      fetchTarball {
        url = "https://github.com/${node.owner}/${node.repo}/archive/${node.rev}.tar.gz";
        sha256 = node.narHash;
      }
    else if node.type == "git"
    then
      fetchTarball {
        url = node.url;
        sha256 = node.narHash;
      }
    else throw "Unsupported lock type '${node.type}' for ${inputName}";

  flakeCompatSrc = fetchInput "flake-compat";
in
  (import flakeCompatSrc {
    src = ./.;
    copySourceTreeToStore = false;
    useBuiltinsFetchTree = true;
  }).defaultNix
