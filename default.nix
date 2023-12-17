# Helpful documentation: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
{ lib, stdenv, installShellFiles, rustPlatform, cmake, pkg-config, fontconfig
, android-tools, mold, clang, gcc_multi, binutils, freetype }:
rustPlatform.buildRustPackage rec {
  name = "uad";

  src = lib.cleanSource ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    # Allow dependencies to be fetched from git and avoid having to set the outputHashes manually
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [
    installShellFiles
    cmake
    pkg-config
    clang
    mold
    pkg-config
    fontconfig
    # gcc_multi
    binutils
    freetype
  ];

  buildInputs = [ clang mold pkg-config fontconfig gcc_multi binutils ];

  doCheck = false; # No tests
  meta = with lib; {
    description = "uad";
    homepage = "";
    license = licenses.mit;
  };
}
