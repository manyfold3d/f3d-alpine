ALPINE_MAJOR = 3
ALPINE_MINOR = 23
ALPINE_PATCH = 3

aarch64: arch := aarch64
aarch64: archopts := -accel hvf -machine virt -cpu host -bios /opt/homebrew/share/qemu/edk2-aarch64-code.fd
aarch64: setup run

x86_64: arch := x86_64
x86_64: archopts := -accel tcg -machine pc-i440fx-10.2 -cpu max
x86_64: setup run

setup: dependencies cache/$(arch)/alpine-standard-${ALPINE_MAJOR}.${ALPINE_MINOR}.${ALPINE_PATCH}-${ARCH}.iso cache/${ARCH}/vda.qcow2

dependencies:
	brew install qemu

%.qcow2:
	qemu-img create -f qcow2 $@ 8G

%.iso:
	wget https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_MAJOR}.${ALPINE_MINOR}/releases/${ARCH}/alpine-standard-${ALPINE_MAJOR}.${ALPINE_MINOR}.${ALPINE_PATCH}-${ARCH}.iso -O $@

run: setup
	qemu-system-$(arch) $(archopts) \
		-m 2048 \
		-drive if=virtio,file=cache/$(arch)/vda.qcow2 \
		-cdrom cache/$(arch)/alpine-standard-${ALPINE_MAJOR}.${ALPINE_MINOR}.${ALPINE_PATCH}-$(arch).iso \
		-boot d \
		-serial stdio \
		-netdev user,id=eth0 \
		-device virtio-net-pci,netdev=eth0 \
		-display cocoa
