{
  declInput
}:
let
  pkgs = import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixos-unstable-2018-09-12";
  # Commit hash for nixos-unstable as of 2018-09-12
  url = "https://github.com/nixos/nixpkgs/archive/ca2ba44cab47767c8127d1c8633e2b581644eb8f.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "1jg7g6cfpw8qvma0y19kwyp549k1qyf11a5sg6hvn6awvmkny47v";
}) {};
in
{
  # jobsets = declInput + "./test.json";
  # jobsets = declInput + "./test.json";
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON {});
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
