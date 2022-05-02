{
  declInput,
  nixpkgs,
  prs
}:
let
  pkgs = import nixpkgs {};
in
{
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON {
    merde = prs;
    hello = {
      enabled = 1;
      hidden = false;
      description = "TEST";
      checkinterval = 0;
      schedulingshares = 100;
      enableemail = false;
      enable_dynamic_run_command = false;
      emailoverride = false;
      keepnr = 3;
      flake = "github:W95Psp/test-hydra/master";
    };
  });
}
# throw (builtins.toJSON declInput)
# {
#   jobsets = {
#     jobsets = {
      
#     };
#   };
# }

# {
#   nixpkgs#@, prs, declInput
#     ,...
# }:
# let
#   pkgs = import nixpkgs {};
#   jobsetsAttrs = {
#     nixpkgs = {
#       enabled = 1;
#       hidden = false;
#       description = "TEST";
#       checkinterval = 0;
#       schedulingshares = 100;
#       enableemail = false;
#       enable_dynamic_run_command = false;
#       emailoverride = "";
#       keepnr = 3;
#       flake = "git+ssh://git@github.com/W95Psp/test-hydra";
#     };
#   };
# in {
#   jobsets = builtins.throw "xxx";
#   # jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
#   # jobsets = pkgs.runCommand "spec.json" {} ''
#   #   cat <<EOF
#   #   ${builtins.toJSON {inherit jobsetsAttrs prs;}}
#   #   EOF
#   #   cp ${pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs)} $out
#   # '';
# }
