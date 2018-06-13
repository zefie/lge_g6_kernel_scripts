#!/bin/bash
source .zefie/scripts/buildenv.sh

Z_LINPATH="/home/zefie/g6dev/debian/debian-arm64"
KERNEL_IMAGE="build/arch/${ARCH}/boot/Image.gz-dtb"

if [ ! -f "${KERNEL_IMAGE}" ]; then
	echo "Could not find binary kernel. Did you build it?";
        echo ""
        echo "Try all of the following:"
        echo ".zefie/scripts/resetgit.sh"
        echo ".zefie/scripts/cleanbuild.sh"
        echo ".zefie/scripts/install-linkern.sh"
	exit 1;
fi

KVER=$(strings build/init/version.o | grep "Linux version" | cut -d' ' -f3 | cut -d'-' -f1-)

if [ -d "${Z_LINPATH}" ]; then
	echo "Installing kernel modules to ${Z_LINPATH}..."
	if [ -d "${Z_LINPATH}/lib/modules" ]; then
		sudo rm -rf "${Z_LINPATH}/lib/modules"
	fi
	sudo .zefie/scripts/make.sh INSTALL_MOD_PATH="${Z_LINPATH}" modules_install 2>&1 > /dev/null
	echo "Installing kernel..."
	sudo cp "${KERNEL_IMAGE}" "${Z_LINPATH}/boot/Image.gz-dtb"
	echo "Updating initrd and generating boot.img under bootstrapped linux..."
	if [ -f "${Z_LINPATH}/boot/initrd.img-${KVER}" ]; then
		sudo rm -f "${Z_LINPATH}/boot/initrd.img-${KVER}";
	fi
	sudo chroot "${Z_LINPATH}" update-initramfs -c -k ${KVER}
else
	echo "${Z_LINPATH} could not be found"
	exit 1;
fi
