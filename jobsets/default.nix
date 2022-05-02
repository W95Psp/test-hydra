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
  mkPR = id: info: {
    name = "pr${id}";
    value = mk "PR ${id}: ${info.title}" "git+ssh://git@github.com/${info.head.repo.full_name}?ref=${info.head.ref}";
  };
  mk = description: flake: {
    inherit description flake;
    enabled = 1;
    type = 1;
    hidden = false;
    checkinterval = 300;
    schedulingshares = 10;
    enableemail = false;
    emailoverride = "";
    keepnr = 50;
  };
  attrsToList = l:
    builtins.attrValues (
      builtins.mapAttrs (name: value: {inherit name value;}) l
    );
  throwJSON = x: throw (builtins.toJSON x);
  prs-value = builtins.fromJSON (builtins.readFile prs);
in
{
  # jobsets = throw (builtins.toJSON prs);
  jobsets = makeSpec (
    builtins.listToAttrs (map ({name, value}: mkPR name value) (attrsToList prs-value)) // {
      master = mk "master" "git+ssh://git@github.com/W95Psp/test-hydra";
    }
  );
}
