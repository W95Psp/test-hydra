
{
  description = "...";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ...}:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      rec {
        packages.x86_64-linux.hey = pkgs.hello;
        defaultPackage.x86_64-linux = pkgs.writeText "x" "o";
        hydraJobs.x86_64-linux.test = pkgs.runCommand "test" {} ''
          mkdir -p "$out"/nix-support "$out"/test
          for i in $(seq 1 30); do
              echo "Dummy log output $i"
              sleep 1
          done
          echo "doc manual $out/test" >> $out/nix-support/hydra-build-products
          echo '<b>Example HTML manual product<b>Date: mar. 03 mai 2022 11:13:53 CEST' > $out/test/index.html
        '';
      };
  
}



