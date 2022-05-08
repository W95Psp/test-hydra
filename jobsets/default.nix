{ declInput, prs, refs }:
let
  makeSpec = contents: builtins.derivation {
    name = "spec.json";
    system = "x86_64-linux";
    preferLocalBuild = true;
    allowSubstitutes = false;
    builder = "/bin/sh";
    args = [ (builtins.toFile "builder.sh" ''
      echo "$contents" > $out
    '') ];
    contents = builtins.toJSON contents;
  };
  jobOfPR = id: info: {
    name = "pr-${id}";
    value = makeJob {
      description = "PR ${id}: ${info.title}";
      flake = "git+ssh://git@github.com/${info.head.repo.full_name}?ref=${info.head.ref}";
    };
  };
  repo = "W95Psp/test-hydra";
  jobOfRef = name: {ref, ...}: 
    if isNull (builtins.match "^refs/heads/(.*)$" ref)
    then null
    else {
      name = "branch-${name}";
      value = makeJob {
        description = "Branch ${name}";
        flake = "git+ssh://git@github.com/${repo}?ref=${ref}";
      };
    };
  makeJob = {schedulingshares ? 10, keepnr ? 1, description, flake}: {
    inherit description flake schedulingshares keepnr;
    enabled = 1;
    type = 1;
    hidden = false;
    checkinterval = 999999999;
    enableemail = false;
    emailoverride = "";
  };
  attrsToList = l:
    builtins.attrValues (
      builtins.mapAttrs (name: value: {inherit name value;}) l
    );
  readJSONFile = f: builtins.fromJSON (builtins.readFile f);
  throwJSON = x: throw (builtins.toJSON x);
  mapFilter = f: l: builtins.filter (x: !(isNull x)) (map f l);
in
{
  # jobsets = makeSpec (
  jobsets = makeSpec (
    builtins.listToAttrs (map ({name, value}: jobOfPR name value) (attrsToList (readJSONFile prs))) //
    builtins.listToAttrs (mapFilter ({name, value}: jobOfRef name value) (attrsToList (readJSONFile refs))) // {
      master = makeJob {
        description = "master";
        flake = "git+ssh://git@github.com/W95Psp/test-hydra";
        keepnr = 10;
        schedulingshares = 100;
      };
    }
  );
}
