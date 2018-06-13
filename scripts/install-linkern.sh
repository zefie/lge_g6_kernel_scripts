#!/bin/bash
Z_LINPATH="/home/zefie/g6dev/debian/debian-arm64"

if [ -d "${Z_LINPATH}" ]; then
	echo "Installing kernel modules to ${Z_LINPATH}..."
	if [ -d "${Z_LINPATH}/lib/modules" ]; then
		sudo rm -rf "${Z_LINPATH}/lib/modules"
	fi
	sudo .zefie/scripts/make.sh INSTALL_MOD_PATH="${Z_LINPATH}" modules_install 2>&1 >/dev/null
	echo "Installing kernel..."
	sudo cp build/arch/arm64/boot/Image.gz-dtb "${Z_LINPATH}/boot/"
	echo "Updating initrd and generating boot.img under bootstrapped linux..."
	sudo chroot "${Z_LINPATH}" update-initramfs -u
else
	echo "${Z_LINPATH} could not be found"
	exit 1;
fi
