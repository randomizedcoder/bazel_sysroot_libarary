# Bazel Sysroot Library

This repository provides a common set of system libraries and headers for Bazel builds. It includes essential libraries for most C/C++ projects, such as compression, networking, XML parsing, and more.

## Included Libraries

The sysroot includes a comprehensive set of libraries. [Click here to see the full list](default.nix#L5).

## Installation

To use this sysroot, you'll need to have Nix installed. If you don't have Nix installed yet, please follow the [Nix Installation Guide](https://nixos.wiki/wiki/Nix_Installation_Guide).

## Usage

This repository includes a Makefile with several useful targets. To see all available commands, run:

```bash
make help
```

The main targets are:
- `make build` - Build the sysroot
- `make tarball` - Create a distributable .tar.gz archive
- `make update-flake` - Update dependencies
- `make push` - Push changes to GitHub

## Self-Hosting

If you need to host the sysroot tarball yourself (e.g., without GitHub access), you can:
1. Run `make tarball` to create the archive
2. Host the resulting `bazel-sysroot-library.tar.gz` on your web server
3. Update your Bazel WORKSPACE to point to your hosted tarball
