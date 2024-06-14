# Helpful documentation: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
{
  lib,
  stdenv,
  rustPlatform,
  cmake,
  pkg-config,
  fontconfig,
  mold,
  freetype,
  autoPatchelfHook,
  makeWrapper,
  xorg,
  wayland,
  wayland-protocols,
  vulkan-loader,
  vulkan-tools,
  clang,
}:
rustPlatform.buildRustPackage rec {
  name = "uad";

  src = lib.cleanSource ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    # Allow dependencies to be fetched from git and avoid having to set the outputHashes manually
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    autoPatchelfHook
    pkg-config
    mold
    clang
  ];

  buildInputs = [
    fontconfig
    freetype
    stdenv.cc.cc.lib # libstdc++.so libgcc_s.so
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    wayland
    wayland-protocols
    vulkan-loader
    vulkan-tools
  ];

  LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${lib.makeLibraryPath buildInputs}";

  # postFixup = ''
  #   patchelf \
  #       --add-needed ${freetype}/lib/libfreetype.so \
  #       $out/bin/uad_gui
  # '';

  doCheck = false; # No tests
  meta = with lib; {
    description = "uad";
    homepage = "";
    license = licenses.mit;
  };
}
