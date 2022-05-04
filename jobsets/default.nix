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
    value = makeJob {
      description = "PR ${id}: ${info.title}";
      flake = "git+ssh://git@github.com/${info.head.repo.full_name}?ref=${info.head.ref}";
    };
  };
  makeJob = {schedulingshares ? 10, keepnr ? 1, description, flake}: {
    inherit description flake schedulingshares keepnr;
    enabled = 1;
    type = 1;
    hidden = false;
    checkinterval = 0;
    enableemail = false;
    emailoverride = "";
  };
  attrsToList = l:
    builtins.attrValues (
      builtins.mapAttrs (name: value: {inherit name value;}) l
    );
  prs-value = builtins.fromJSON (builtins.readFile prs);
  throwJSON = x: throw (builtins.toJSON x);
in
{
  # jobsets = makeSpec (
  jobsets = makeSpec (
    builtins.listToAttrs (map ({name, value}: jobOfPR name value) (attrsToList prs-value)) // {
      master = makeJob {
        description = "master";
        flake = "git+ssh://git@github.com/W95Psp/test-hydra";
        keepnr = 10;
        schedulingshares = 100;
      };
    }
  );
}
