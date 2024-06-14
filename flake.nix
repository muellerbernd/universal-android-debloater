{
  description = "Cross-platform GUI written in Rust using ADB to debloat non-rooted android devices. Improve your privacy, the security and battery life of your device. ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.outputs.legacyPackages.${system};
    in {
      packages.default = pkgs.callPackage ./. {};
      devShells.default = import ./shell.nix {inherit pkgs;};
    })
    // {
      overlays.default = final: prev: {
        inherit (self.packages.${final.system}) uad;
      };
    };
}
