
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
          mkdir -p $out/nix-support $out/test
          echo "je suxxis là"
          echo "je suis là"
          echo "asdasjd"
          echo 'doc someting $out/test/a' >> $out/nix-support/hydra-build-products
          echo "doc manual $out/test" >> $out/nix-support/hydra-build-products
          echo 'asdasdxxx' > $out/test/a
          echo 'xxxx' > $out/test/b
          echo '<b>xxxx/hey<b>here1643031309PPP' > $out/test/index.html
        '';
      };
  
}



