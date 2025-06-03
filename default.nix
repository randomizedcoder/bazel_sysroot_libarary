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

  build_file_content = ''
package(default_visibility = ["//visibility:public"])

# Main filegroup that includes everything
filegroup(
    name = "all",
    srcs = [
        ":include",
        ":lib",
    ],
)

# Include directory filegroup
filegroup(
    name = "include",
    srcs = glob(["include/**"]),
    allow_empty = True,
)

# Library directory filegroup
filegroup(
    name = "lib",
    srcs = glob(["lib/**"]),
    allow_empty = True,
)

# Shared library target
cc_library(
    name = "system_deps",
    srcs = glob(["lib/*.so*"]),
    hdrs = glob(["include/**/*.h"]),
    includes = ["include"],
    linkstatic = 0,
    visibility = ["//visibility:public"],
)

# Static library target
cc_library(
    name = "system_deps_static",
    srcs = glob(["lib/*.a"]),
    hdrs = glob(["include/**/*.h"]),
    includes = ["include"],
    linkstatic = 1,
    visibility = ["//visibility:public"],
)
'';
in
pkgs.stdenv.mkDerivation {
  name = "bazel-sysroot-library";
  version = "1.0.0";

  buildInputs = commonLibs;

  buildCommand = ''
    # Create sysroot directory structure
    mkdir -p $out/sysroot/{include,lib}

    # Copy headers
    echo "Copying headers..."
    if [ -d "${pkgs.glibc.dev}/include" ]; then cp -r ${pkgs.glibc.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.gcc-unwrapped.lib}/include" ]; then cp -r ${pkgs.gcc-unwrapped.lib}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.zlib.dev}/include" ]; then cp -r ${pkgs.zlib.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.bzip2.dev}/include" ]; then cp -r ${pkgs.bzip2.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.xz.dev}/include" ]; then cp -r ${pkgs.xz.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.libxml2.dev}/include" ]; then cp -r ${pkgs.libxml2.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.expat.dev}/include" ]; then cp -r ${pkgs.expat.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.openssl.dev}/include" ]; then cp -r ${pkgs.openssl.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.curl.dev}/include" ]; then cp -r ${pkgs.curl.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.pcre.dev}/include" ]; then cp -r ${pkgs.pcre.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.pcre2.dev}/include" ]; then cp -r ${pkgs.pcre2.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.jansson.dev}/include" ]; then cp -r ${pkgs.jansson.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.sqlite.dev}/include" ]; then cp -r ${pkgs.sqlite.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.libpng.dev}/include" ]; then cp -r ${pkgs.libpng.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.libjpeg.dev}/include" ]; then cp -r ${pkgs.libjpeg.dev}/include/* $out/sysroot/include/ || true; fi
    if [ -d "${pkgs.util-linux.dev}/include" ]; then cp -r ${pkgs.util-linux.dev}/include/* $out/sysroot/include/ || true; fi

    # Copy libraries
    echo "Copying libraries..."
    if [ -d "${pkgs.glibc}/lib" ]; then cp -r ${pkgs.glibc}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.glibc.dev}/lib" ]; then cp -r ${pkgs.glibc.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.glibc.static}/lib" ]; then cp -r ${pkgs.glibc.static}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.gcc-unwrapped.lib}/lib" ]; then cp -r ${pkgs.gcc-unwrapped.lib}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.gcc-unwrapped.out}/lib" ]; then cp -r ${pkgs.gcc-unwrapped.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.zlib}/lib" ]; then cp -r ${pkgs.zlib}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.zlib.dev}/lib" ]; then cp -r ${pkgs.zlib.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.zlib.static}/lib" ]; then cp -r ${pkgs.zlib.static}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.bzip2}/lib" ]; then cp -r ${pkgs.bzip2}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.bzip2.dev}/lib" ]; then cp -r ${pkgs.bzip2.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.xz}/lib" ]; then cp -r ${pkgs.xz}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.xz.dev}/lib" ]; then cp -r ${pkgs.xz.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libxml2}/lib" ]; then cp -r ${pkgs.libxml2}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libxml2.dev}/lib" ]; then cp -r ${pkgs.libxml2.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libxml2.out}/lib" ]; then cp -r ${pkgs.libxml2.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.expat}/lib" ]; then cp -r ${pkgs.expat}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.expat.dev}/lib" ]; then cp -r ${pkgs.expat.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.expat.out}/lib" ]; then cp -r ${pkgs.expat.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.openssl}/lib" ]; then cp -r ${pkgs.openssl}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.openssl.dev}/lib" ]; then cp -r ${pkgs.openssl.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.openssl.out}/lib" ]; then cp -r ${pkgs.openssl.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.curl}/lib" ]; then cp -r ${pkgs.curl}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.curl.dev}/lib" ]; then cp -r ${pkgs.curl.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.curl.out}/lib" ]; then cp -r ${pkgs.curl.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.pcre}/lib" ]; then cp -r ${pkgs.pcre}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.pcre.dev}/lib" ]; then cp -r ${pkgs.pcre.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.pcre.out}/lib" ]; then cp -r ${pkgs.pcre.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.pcre2}/lib" ]; then cp -r ${pkgs.pcre2}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.pcre2.dev}/lib" ]; then cp -r ${pkgs.pcre2.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.pcre2.out}/lib" ]; then cp -r ${pkgs.pcre2.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.jansson}/lib" ]; then cp -r ${pkgs.jansson}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.jansson.dev}/lib" ]; then cp -r ${pkgs.jansson.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.jansson.out}/lib" ]; then cp -r ${pkgs.jansson.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.sqlite}/lib" ]; then cp -r ${pkgs.sqlite}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.sqlite.dev}/lib" ]; then cp -r ${pkgs.sqlite.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.sqlite.out}/lib" ]; then cp -r ${pkgs.sqlite.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libpng}/lib" ]; then cp -r ${pkgs.libpng}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libpng.dev}/lib" ]; then cp -r ${pkgs.libpng.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libpng.out}/lib" ]; then cp -r ${pkgs.libpng.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libjpeg}/lib" ]; then cp -r ${pkgs.libjpeg}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libjpeg.dev}/lib" ]; then cp -r ${pkgs.libjpeg.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.libjpeg.out}/lib" ]; then cp -r ${pkgs.libjpeg.out}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.util-linux}/lib" ]; then cp -r ${pkgs.util-linux}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.util-linux.dev}/lib" ]; then cp -r ${pkgs.util-linux.dev}/lib/* $out/sysroot/lib/ || true; fi
    if [ -d "${pkgs.util-linux.out}/lib" ]; then cp -r ${pkgs.util-linux.out}/lib/* $out/sysroot/lib/ || true; fi

    # Create sysroot.BUILD file
    cat > $out/sysroot/BUILD.sysroot.bazel << 'EOF'
${build_file_content}
EOF
  '';
}