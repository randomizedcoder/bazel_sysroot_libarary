# bazel_sysroot_library

This sysroot provides common headers and system libraries shared across architectures for Bazel builds. It is designed to be used in conjunction with architecture-specific sysroots for AMD64 and ARM64.

## Purpose

The `bazel_sysroot_library` sysroot serves as a common base for all architectures, providing:
- Common header files (`.h`) used across architectures
- Common system libraries (both shared `.so` and static `.a`)
- System dependencies that are architecture-independent

## Directory Structure

```
sysroot/
├── include/     # Common header files
├── lib/         # Common system libraries
└── BUILD.sysroot.bazel
```

## BUILD.sysroot.bazel

The BUILD file exposes the following targets:

1. **Filegroups**:
   - `:all` - Includes both `:include` and `:lib`
   - `:include` - All header files in the include directory
   - `:lib` - All library files in the lib directory

2. **Library Targets**:
   - `:system_deps` - Shared library target for dynamic linking
   - `:system_deps_static` - Static library target for static linking

## Included Libraries

The sysroot includes the following common libraries and their headers:

- Core system libraries:
  - glibc
  - gcc-unwrapped

- Compression libraries:
  - zlib
  - bzip2
  - xz

- XML and parsing:
  - libxml2
  - expat

- Networking:
  - openssl
  - curl

- Text processing:
  - pcre
  - pcre2

- JSON:
  - jansson

- Database:
  - sqlite

- Image processing:
  - libpng
  - libjpeg

- System utilities:
  - util-linux

## Usage in Bazel

This sysroot is typically used in conjunction with architecture-specific sysroots:

```python
llvm.sysroot(
    name = "llvm_toolchain",
    targets = ["linux-x86_64"],
    label = "@bazel_sysroot_tarball_amd64//:sysroot",
    include_prefix = "@bazel_sysroot_library//:include",
    lib_prefix = "@bazel_sysroot_lib_amd64//:lib",
    system_libs = [
        "@bazel_sysroot_library//:system_deps",
        "@bazel_sysroot_library//:system_deps_static",
    ],
)
```

## Building

To build this sysroot:

```bash
nix-build default.nix
```

The output will be a directory containing the sysroot structure with all necessary files and the BUILD.sysroot.bazel file.
