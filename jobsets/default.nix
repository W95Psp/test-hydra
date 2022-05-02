{
  declInput,
  nixpkgs,
  prs
}:
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
  mk = branch: makeSpec {
    enabled = 1;
    type = 1;
    hidden = false;
    description = "foo description";
    flake = "git+ssh://git@github.com/W95Psp/test-hydra?ref=${branch}";
    checkinterval = 300;
    schedulingshares = 10;
    enableemail = false;
    emailoverride = "";
    keepnr = 50;
  };
in
{
  jobsets = makeSpec (builtins.listToAttrs (map (branch: {
    name = branch;
    value = mk branch;
  }) ["master"]));
}
