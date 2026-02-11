# F3D Alpine package builder environment using macOS / QEMU

This repo sets up an Alpine build environment using QEMU on macOS, intended for packaging [F3D](https://f3d.app) using `src/APKBUILD`.

F3D APKBUILD packaging work originally by Saijin-Naib at https://pastebin.com/2ckHAs2Q.

## Usage

Simply run `run.sh aarch64` or `run.sh x86_64` depending on which architecture you want.

On first run, it will download the relevant installer ISO and boot it, at which point you can run `setup-alpine` to install properly to the disk `vda`.

On subsequent runs, it will boot from `vda` and bring up your existing system.

## Building

Once you have a running machine:

1. Follow the [Alpine build environment guide](https://wiki.alpinelinux.org/wiki/Setting_up_the_build_environment_on_HDD)
2. Enable the Alpine community repository with `setup-apkrepos -c`; lots of the dependencies are in there.
3. Copy `src/APKBUILD` into your Alpine VM
4. Execute `abuild -r`.
5. Copy the built packages out of the VM for publishing.
