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
3. Copy `src/f3d/APKBUILD` into your Alpine VM (see below)
4. Execute `abuild -r`.

## Copying files

By default, the run script will map the `src` directory to `/dev/vdb1` inside the VM. You can mount that inside the VM like so:

`doas mount -t vfat /dev/vdb1 {mount_point}`

Then you can copy files in and out, though note that it only syncs the real and virtual folders at machine start and shutdown.
