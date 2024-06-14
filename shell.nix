{pkgs}:
pkgs.mkShell rec {
  name = "UAD development";

  # Get dependencies from the main package
  inputsFrom = [(pkgs.callPackage ./default.nix {})];
  # Additional tooling
  buildInputs = with pkgs; [
    rust-analyzer # LSP Server
    rustfmt # Formatter
    clippy # Linter
    clang
    freetype
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
  LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}";
}
