#!/bin/bash
source .zefie/scripts/buildenv.sh
rm -rf "${KERNEL_BUILDDIR}"/*
.zefie/scripts/resetgit.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo "Error while resetting git."
	exit $RC
fi
.zefie/scripts/prepare.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo "Error while preparing kernel."
	exit $RC
fi
.zefie/scripts/mrproper.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo "Error doing kernel mrproper."
	exit $RC
fi
.zefie/scripts/defconfig.sh
RC=$?
if [ $RC -ne 0 ]; then
	echo "Error while generating kernel config."
	exit $RC
fi

