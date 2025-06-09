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
    mkdir -p $out/sysroot/usr/include/c++
    mkdir -p $out/sysroot/usr/lib

    # Copy headers
    echo "Copying headers..."
    if [ -d "${pkgs.glibc.dev}/include" ]; then cp -rL ${pkgs.glibc.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.gcc-unwrapped.lib}/include" ]; then cp -rL ${pkgs.gcc-unwrapped.lib}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.gcc-unwrapped}/include/c++/14.2.1.20250322" ]; then cp -rL ${pkgs.gcc-unwrapped}/include/c++/14.2.1.20250322/* $out/sysroot/usr/include/c++/ || true; fi
    if [ -d "${pkgs.zlib.dev}/include" ]; then cp -rL ${pkgs.zlib.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.bzip2.dev}/include" ]; then cp -rL ${pkgs.bzip2.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.xz.dev}/include" ]; then cp -rL ${pkgs.xz.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.libxml2.dev}/include" ]; then cp -rL ${pkgs.libxml2.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.expat.dev}/include" ]; then cp -rL ${pkgs.expat.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.openssl.dev}/include" ]; then cp -rL ${pkgs.openssl.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.curl.dev}/include" ]; then cp -rL ${pkgs.curl.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.pcre.dev}/include" ]; then cp -rL ${pkgs.pcre.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.pcre2.dev}/include" ]; then cp -rL ${pkgs.pcre2.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.jansson.dev}/include" ]; then cp -rL ${pkgs.jansson.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.sqlite.dev}/include" ]; then cp -rL ${pkgs.sqlite.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.libpng.dev}/include" ]; then cp -rL ${pkgs.libpng.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.libjpeg.dev}/include" ]; then cp -rL ${pkgs.libjpeg.dev}/include/* $out/sysroot/usr/include/ || true; fi
    if [ -d "${pkgs.util-linux.dev}/include" ]; then cp -rL ${pkgs.util-linux.dev}/include/* $out/sysroot/usr/include/ || true; fi

    # Copy libraries
    echo "Copying libraries..."
    # First copy the actual library files
    if [ -d "${pkgs.glibc}/lib" ]; then
      for lib in ${pkgs.glibc}/lib/*.so*; do
        if [ -f "$lib" ]; then
          cp -L "$lib" $out/sysroot/usr/lib/ || true
        fi
      done
    fi
    if [ -d "${pkgs.glibc.dev}/lib" ]; then
      for lib in ${pkgs.glibc.dev}/lib/*.so*; do
        if [ -f "$lib" ]; then
          cp -L "$lib" $out/sysroot/usr/lib/ || true
        fi
      done
    fi
    if [ -d "${pkgs.glibc.static}/lib" ]; then
      for lib in ${pkgs.glibc.static}/lib/*.a; do
        if [ -f "$lib" ]; then
          cp -L "$lib" $out/sysroot/usr/lib/ || true
        fi
      done
    fi
    if [ -d "${pkgs.gcc-unwrapped.lib}/lib" ]; then
      for lib in ${pkgs.gcc-unwrapped.lib}/lib/*.so*; do
        if [ -f "$lib" ]; then
          cp -L "$lib" $out/sysroot/usr/lib/ || true
        fi
      done
    fi
    if [ -d "${pkgs.gcc-unwrapped.out}/lib" ]; then
      for lib in ${pkgs.gcc-unwrapped.out}/lib/*.so*; do
        if [ -f "$lib" ]; then
          cp -L "$lib" $out/sysroot/usr/lib/ || true
        fi
      done
    fi

    # Copy other libraries
    for pkg in ${pkgs.zlib} ${pkgs.zlib.dev} ${pkgs.zlib.static} \
               ${pkgs.bzip2} ${pkgs.bzip2.dev} \
               ${pkgs.xz} ${pkgs.xz.dev} \
               ${pkgs.libxml2} ${pkgs.libxml2.dev} ${pkgs.libxml2.out} \
               ${pkgs.expat} ${pkgs.expat.dev} ${pkgs.expat.out} \
               ${pkgs.openssl} ${pkgs.openssl.dev} ${pkgs.openssl.out} \
               ${pkgs.curl} ${pkgs.curl.dev} ${pkgs.curl.out} \
               ${pkgs.pcre} ${pkgs.pcre.dev} ${pkgs.pcre.out} \
               ${pkgs.pcre2} ${pkgs.pcre2.dev} ${pkgs.pcre2.out} \
               ${pkgs.jansson} ${pkgs.jansson.dev} ${pkgs.jansson.out} \
               ${pkgs.sqlite} ${pkgs.sqlite.dev} ${pkgs.sqlite.out} \
               ${pkgs.libpng} ${pkgs.libpng.dev} ${pkgs.libpng.out} \
               ${pkgs.libjpeg} ${pkgs.libjpeg.dev} ${pkgs.libjpeg.out} \
               ${pkgs.util-linux} ${pkgs.util-linux.dev} ${pkgs.util-linux.out}; do
      if [ -d "$pkg/lib" ]; then
        for lib in $pkg/lib/*.so* $pkg/lib/*.a; do
          if [ -f "$lib" ]; then
            cp -L "$lib" $out/sysroot/usr/lib/ || true
          fi
        done
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