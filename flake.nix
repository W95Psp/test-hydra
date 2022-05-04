
{
  description = "...";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    test.url = "git+https://git.franceschino.fr/Lucas/test.git";
    test.flake = false;
  };

  outputs = { self, nixpkgs, test, ...}:
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
          echo '<b>Example HTML manual product<b>Date: mer. 04 mai 2022 10:28:56 CEST' > $out/test/index.html
          cat ${test}/README.md >> $out/test/index.html
        '';
      };
  
}



