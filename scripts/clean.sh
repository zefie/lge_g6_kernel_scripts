#!/bin/bash
source .zefie/scripts/buildenv.sh
if [ -z "${KERNEL_BUILDDIR}" ]; then
	exit 1; # die before we destroy stuff
fi
rm -rf "${KERNEL_BUILDDIR}"/*
.zefie/scripts/resetgit.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo "Error while resetting git."
	exit $RC
fi
.zefie/scripts/mrproper.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo "Error doing kernel mrproper."
	exit $RC
fi
rm -f "${DEFCONFIG_DIR}/"${KERNEL_NAME_LOWER}_*_defconfig
.zefie/scripts/defconfig.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo "Error while generating kernel config."
	exit $RC
fi

