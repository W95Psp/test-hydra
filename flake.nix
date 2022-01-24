
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
        hydraJobs.x86_64-linux.test = pkgs.writeText "x" "here1643022012!!";
      };
  
}



