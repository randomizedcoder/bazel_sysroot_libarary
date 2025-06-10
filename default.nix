{ pkgs ? import <nixpkgs> {} }:

let
  # Common libraries and headers needed for most builds
  commonLibs = with pkgs; [
    # Core system libraries
    glibc glibc.dev glibc.static
    gcc-unwrapped gcc-unwrapped.lib gcc-unwrapped.out

    # Compression libraries
    zlib zlib.dev zlib.static
    bzip2 bzip2.dev
    xz xz.dev

    # XML and parsing
    libxml2 libxml2.dev libxml2.out
    expat expat.dev expat.out

    # Networking
    openssl openssl.dev openssl.out
    curl curl.dev curl.out

    # Text processing
    pcre pcre.dev pcre.out
    pcre2 pcre2.dev pcre2.out

    # JSON
    jansson jansson.dev jansson.out

    # Database
    sqlite sqlite.dev sqlite.out

    # Image processing
    libpng libpng.dev libpng.out
    libjpeg libjpeg.dev libjpeg.out

    # System utilities
    util-linux util-linux.dev util-linux.out
  ];

  # Core system packages that need special handling
  corePackages = with pkgs; [
    { pkg = glibc; include = "/include"; lib = "/lib"; patterns = ["*"]; }
    { pkg = glibc.dev; include = "/include"; lib = "/lib"; patterns = ["*"]; }
    { pkg = glibc.static; lib = "/lib"; patterns = ["*.a"]; }
    { pkg = gcc-unwrapped.lib; include = "/include"; lib = "/lib"; patterns = ["*"]; }
    { pkg = gcc-unwrapped.out; lib = "/lib"; patterns = ["*.so*"]; }
  ];

  # GCC specific paths
  gccPaths = with pkgs; [
    { pkg = gcc-unwrapped; include = "/include/c++/14.2.1.20250322"; dest = "/usr/include/c++/14.2.1.20250322"; patterns = ["*"]; }
    { pkg = gcc-unwrapped.out; include = "/lib/gcc/x86_64-unknown-linux-gnu/14.2.1/include"; dest = "/usr/lib/gcc/x86_64-unknown-linux-gnu/14.2.1/include"; patterns = ["*"]; }
  ];

  # Helper function to create copy commands
  mkCopyCmd = { pkg, include ? null, lib ? null, dest ? null, patterns }: let
    targetPath = if dest != null then "\"$out/sysroot${dest}\"" else "\"$out/sysroot/usr/include\"";
    sourcePath = if include != null then "${pkg}${include}" else "${pkg}${lib}";
  in
    if include != null then
      "mkdir -p ${targetPath} && " +
      "if [ -d \"${sourcePath}\" ]; then " +
      "for file in ${pkgs.lib.concatStringsSep " " (map (pattern: "${sourcePath}/${pattern}") patterns)}; do " +
      "if [ -f \"$file\" ] || [ -d \"$file\" ]; then " +
      "cp --dereference --recursive \"$file\" ${targetPath}/ || true; " +
      "fi; done; fi"
    else if lib != null then
      "if [ -d \"${sourcePath}\" ]; then " +
      "for lib in ${pkgs.lib.concatStringsSep " " (map (pattern: "${sourcePath}/${pattern}") patterns)}; do " +
      "if [ -f \"$lib\" ]; then " +
      "cp --dereference --recursive \"$lib\" \"$out/sysroot/usr/lib/\" || true; " +
      "fi; done; fi"
    else "";

  # Helper function to create copy commands for common libraries
  mkCommonLibCmd = pkg:
    "if [ -d \"${pkg}/include\" ]; then " +
    "for file in ${pkg}/include/*; do " +
    "if [ -f \"$file\" ] || [ -d \"$file\" ]; then " +
    "cp --dereference --recursive \"$file\" \"$out/sysroot/usr/include/\" || true; " +
    "fi; done; fi";

  # Helper function to create copy commands for common libraries' libs
  mkCommonLibLibCmd = pkg:
    "if [ -d \"${pkg}/lib\" ]; then " +
    "for lib in ${pkg}/lib/*.so* ${pkg}/lib/*.a; do " +
    "if [ -f \"$lib\" ]; then " +
    "cp --dereference --recursive \"$lib\" \"$out/sysroot/usr/lib/\" || true; " +
    "fi; done; fi";
in
pkgs.stdenv.mkDerivation {
  name = "bazel-sysroot-library";
  version = "1.0.0";

  buildInputs = commonLibs;

  buildCommand = ''
    # Create necessary directories
    mkdir -p "$out/sysroot/usr/include/c++/14.2.1.20250322/"
    mkdir -p "$out/sysroot/usr/lib/gcc/x86_64-unknown-linux-gnu/14.2.1/include"

    # Copy headers from core packages
    echo "Copying core headers..."
    ${pkgs.lib.concatStringsSep "\n" (map mkCopyCmd corePackages)}

    # Copy GCC specific paths
    echo "Copying GCC paths..."
    ${pkgs.lib.concatStringsSep "\n" (map mkCopyCmd gccPaths)}

    # Copy headers from other packages
    echo "Copying other headers..."
    ${pkgs.lib.concatStringsSep "\n" (map mkCommonLibCmd (builtins.filter (pkg: !(builtins.elem pkg (map (p: p.pkg) corePackages))) commonLibs))}

    # Copy libraries from other packages
    echo "Copying other libraries..."
    ${pkgs.lib.concatStringsSep "\n" (map mkCommonLibLibCmd (builtins.filter (pkg: !(builtins.elem pkg (map (p: p.pkg) corePackages))) commonLibs))}

    # Copy BUILD.bazel file
    cp "${./bazel/BUILD.bazel}" "$out/sysroot/BUILD.bazel"
  '';

  meta = with pkgs.lib; {
    description = "Libraries for Bazel C/C++ builds";
    homepage = "https://github.com/randomizedcoder/bazel_sysroot_library";
    license = licenses.mit;
  };
}