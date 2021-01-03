# iOS build instructions

## Prerequire

* for building
    * LDC2 (>=1.24.0)
    * Xcode (>=12.3)
        * Apple account registration for App signing.
    * Git
    * curl
* for running
    * iPhone/iPad/iPod touch (>= iOS 14.3)
    * iOS Simulator

## Instructions

### Download and build libraries

Change directory to `libs/` and run follow shells.

1. `00_copy_druntimes.sh`
    * Copy druntime and phobos library files from LDC2 directory.
1. `01_download-and-build-SDL2.sh`
    * Download a SDL2 source tarball and build using iOS configuration.
1. `02_download-and-build-SDL2_mixer.sh`
    * Download a SDL2_mixer source tarball and build using iOS configuration.
1. `03_build-bindbc-sdl.sh`
    * Update bindbc-sdl from Github repository and build with patching to dub.sdl.

### Build tt.app

Change directory to this file directory.

1. `build-ios.sh`
    * Compile `libtt.a` object files.
    * Merge dependency libraries.
    * Build `project/build/tt.app` for iPhone simulator.
1. Build for real iOS devices using Xcode.
    * Setting up signing capability in target configuration.
        * It need Apple developer registration and private key for App signing.
    * Build target `tt` for iOS arm64 architecture.

