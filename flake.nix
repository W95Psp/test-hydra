
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
          echo 'doc Blurpon123 $out/test/a' >> $out/nix-support/hydra-build-products
          echo "doc manual $out/test" >> $out/nix-support/hydra-build-products
          echo 'OHOHXhere1643031309XXX' > $out/test/a
          echo 'OHOHYhere1643031309YYY' > $out/test/b
          echo '<b>ZOHOH/hey<b>here1643031309PPP' > $out/test/index.html
        '';
      };
  
}



