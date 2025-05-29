# Bazel Sysroot for Common Libraries

This repository contains a sysroot with common system libraries and headers that can be used with Bazel builds. It includes essential libraries needed for most C/C++ projects.

## Available Make Targets

- `make help` - Show available targets and their descriptions
- `make update-flake` - Update flake.lock with latest dependencies
- `make build` - Build the common library sysroot using nix build
- `make tarball` - Create a .tar.gz archive of the common library sysroot
- `make nix-tarball` - Create a .tar.gz archive using nix build
- `make copy` - Copy files from Nix store to sysroot directory
- `make push` - Push changes to GitHub with dated commit
- `make update-all` - Update flake, build, copy, and push
- `make clean` - Clean up build artifacts

## Repository Structure

```
.
├── default.nix      # Nix package definition
├── flake.nix        # Nix flake configuration
├── Makefile         # Build and maintenance targets
├── sysroot/         # Sysroot files (generated)
│   ├── include/     # Header files
│   └── lib/         # Library files
└── .gitignore      # Git ignore rules
```

## Usage

1. Build the sysroot:
   ```bash
   make build
   ```

2. Copy files to the repository:
   ```bash
   make copy
   ```

3. Create a tarball:
   ```bash
   make tarball
   # or
   make nix-tarball
   ```

4. Update everything and push:
   ```bash
   make update-all
   ```

## Dependencies

- Nix package manager
- rsync (for copying files)
- git (for version control)
