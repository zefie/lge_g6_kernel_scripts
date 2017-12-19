#!/bin/bash
source .zefie/scripts/buildenv.sh
DEFCONFIG_DIR="arch/${ARCH}/configs"

if [ ! -f "${DEFCONFIG_DIR}/${KERNEL_NAME_LOWER}_zefiescripts_defconfig" ]; then
        echo "Could not find the kernel config. Did you prepare first?"
        echo ""
        echo "Try the following:"
        echo ".zefie/scripts/prepare.sh"
        echo ".zefie/scripts/defconfig.sh"
	exit 1;
fi
.zefie/scripts/make.sh ${KERNEL_NAME_LOWER}_zefiescripts_defconfig
exit $?
