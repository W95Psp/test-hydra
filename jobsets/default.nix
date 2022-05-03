{ declInput, prs }:
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
    name = "pr${id}";
    value = makeJob 10
      "PR ${id}: ${info.title}"
      "git+ssh://git@github.com/${info.head.repo.full_name}?ref=${info.head.ref}";
  };
  makeJob = priority: description: flake: {
    inherit description flake;
    enabled = 1;
    type = 1;
    hidden = false;
    checkinterval = 0;
    schedulingshares = priority;
    enableemail = false;
    emailoverride = "";
    keepnr = 1;
  };
  attrsToList = l:
    builtins.attrValues (
      builtins.mapAttrs (name: value: {inherit name value;}) l
    );
  prs-value = builtins.fromJSON (builtins.readFile prs);
in
{
  jobsets = makeSpec (
    builtins.listToAttrs (map ({name, value}: jobOfPR name value) (attrsToList prs-value)) // {
      master = makeJob "master" "git+ssh://git@github.com/W95Psp/test-hydra" 100;
    }
  );
}
