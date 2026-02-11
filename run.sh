#!/bin/sh

ALPINE_MAJOR=3
ALPINE_MINOR=23
ALPINE_PATCH=3

ARCH=$1


# We need some things installed
brew install qemu wget

IMG=cache/$ARCH/vda.qcow2
if [ -f $IMG ]; then

	echo "Using existing disk at $IMG"

else

 	# Download install image
	ISO=cache/$ARCH/alpine-standard-$ALPINE_MAJOR.$ALPINE_MINOR.$ALPINE_PATCH-$ARCH.iso
	if [ -f $ISO ]; then
		echo "Using cached $ISO"
	else
		wget https://dl-cdn.alpinelinux.org/alpine/v$ALPINE_MAJOR.$ALPINE_MINOR/releases/$ARCH/alpine-standard-$ALPINE_MAJOR.$ALPINE_MINOR.$ALPINE_PATCH-$ARCH.iso -O $ISO
	fi
	BOOTOPTS="-cdrom $ISO -boot d"

	echo "Creating new disk at $IMG"
	qemu-img create -f qcow2 $IMG 8G

fi

if [ $ARCH = "aarch64" ]; then
	ARCHOPTS=-"accel hvf -machine virt -cpu host -bios /opt/homebrew/share/qemu/edk2-aarch64-code.fd"
fi

if [ $ARCH = "x86_64" ]; then
	ARCHOPTS="-accel tcg -machine pc-i440fx-10.2 -cpu max"
fi

qemu-system-$ARCH $ARCHOPTS $BOOTOPTS \
	-m 2048 \
	-drive if=virtio,file=$IMG \
	-serial stdio \
	-netdev user,id=eth0 \
	-device virtio-net-pci,netdev=eth0 \
	-net user,hostfwd=tcp::10022-:22 \
	-net nic \
	-display cocoa
