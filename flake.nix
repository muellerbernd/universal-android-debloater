{
  description =
    "Cross-platform GUI written in Rust using ADB to debloat non-rooted android devices. Improve your privacy, the security and battery life of your device. ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.outputs.legacyPackages.${system};
      in {
        packages.uad = pkgs.callPackage ./uad.nix {
          inherit (pkgs.darwin.apple_sdk.frameworks)
            Security SystemConfiguration AppKit;
        };
        packages.default = self.outputs.packages.${system}.uad;

        devShells.default = self.packages.${system}.default.overrideAttrs
          (super: {
            nativeBuildInputs = with pkgs;
              super.nativeBuildInputs ++ [ cargo-edit clippy rustfmt ];
            RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
          });
      }) // {
        overlays.default = final: prev: {
          inherit (self.packages.${final.system}) uad;
        };
      };
}
