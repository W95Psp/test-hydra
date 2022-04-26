{
  nixpkgs
}:
let
  pkgs = import nixpkgs {};
  jobsetsAttrs = {
    nixpkgs = {
      enabled = 1;
      hidden = false;
      description = "TEST";
      checkinterval = 0;
      schedulingshares = 100;
      enableemail = false;
      enable_dynamic_run_command = false;
      emailoverride = "";
      keepnr = 3;
      flake = "git+ssh://git@github.com/W95Psp/test-hydra";
    };
  };
in {
  jobsets = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);
}
