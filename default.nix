{ pkgs ? import <nixpkgs> {} }:

let
  # Common libraries and headers needed for most builds
  commonLibs = with pkgs; [
    # Core system libraries
    glibc
    glibc.dev
    glibc.static
    gcc-unwrapped
    gcc-unwrapped.lib
    gcc-unwrapped.out

    # Compression libraries
    zlib
    zlib.dev
    zlib.static
    bzip2
    bzip2.dev
    xz
    xz.dev

    # XML and parsing
    libxml2
    libxml2.dev
    libxml2.out
    expat
    expat.dev
    expat.out

    # Networking
    openssl
    openssl.dev
    openssl.out
    curl
    curl.dev
    curl.out

    # Text processing
    pcre
    pcre.dev
    pcre.out
    pcre2
    pcre2.dev
    pcre2.out

    # JSON
    jansson
    jansson.dev
    jansson.out

    # Database
    sqlite
    sqlite.dev
    sqlite.out

    # Image processing
    libpng
    libpng.dev
    libpng.out
    libjpeg
    libjpeg.dev
    libjpeg.out

    # System utilities
    util-linux
    util-linux.dev
    util-linux.out
  ];
in
pkgs.stdenv.mkDerivation {
  name = "bazel-sysroot-library";
  version = "1.0.0";

  buildInputs = commonLibs;

  buildCommand = ''
    mkdir -p $out/sysroot/usr/include
    mkdir -p $out/sysroot/usr/lib

    # Copy glibc headers and libraries
    if [ -d "${pkgs.glibc.dev}/include" ]; then
      cp -r ${pkgs.glibc.dev}/include/* $out/sysroot/usr/include/ || true
    fi
    if [ -d "${pkgs.glibc}/lib" ]; then
      cp -r ${pkgs.glibc}/lib/* $out/sysroot/usr/lib/ || true
    fi

    # Copy gcc-unwrapped headers and libraries
    if [ -d "${pkgs.gcc-unwrapped}/include" ]; then
      cp -r ${pkgs.gcc-unwrapped}/include/* $out/sysroot/usr/include/ || true
    fi
    if [ -d "${pkgs.gcc-unwrapped}/lib" ]; then
      cp -r ${pkgs.gcc-unwrapped}/lib/* $out/sysroot/usr/lib/ || true
    fi

    # Copy other common libraries and headers
    for lib in ${toString commonLibs}; do
      if [ -d "$lib/include" ]; then
        cp -r "$lib/include/"* $out/sysroot/usr/include/ || true
      fi
      if [ -d "$lib/lib" ]; then
        cp -r "$lib/lib/"* $out/sysroot/usr/lib/ || true
      fi
    done

    cp ${./bazel/BUILD.bazel} $out/sysroot/BUILD.bazel
  '';

  meta = with pkgs.lib; {
    description = "Libraries for Bazel C/C++ builds";
    homepage = "https://github.com/randomizedcoder/bazel_sysroot_library";
    license = licenses.mit;
  };
}