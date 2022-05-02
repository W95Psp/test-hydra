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
  mk = id: info: {
    name = "pr${id}";
    value = {
      enabled = 1;
      type = 1;
      hidden = false;
      description = "PR ${id}: ${info.title}";
      flake = "git+${info.head.repo.ssh_url}?ref=${info.head.ref}";
      # flake = "git+ssh://git@github.com/W95Psp/test-hydra?ref=${branch}";
      checkinterval = 300;
      schedulingshares = 10;
      enableemail = false;
      emailoverride = "";
      keepnr = 50;
    };
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
  jobsets = makeSpec (builtins.listToAttrs (map ({name, value}: mk name value) (attrsToList prs-value)));
}
