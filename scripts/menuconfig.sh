#!/bin/bash
if [ ! -z "${CLEAN}" ]; then
	echo "Cleaning kernel and regenerating config..."
	.zefie/scripts/clean.sh
fi
.zefie/scripts/buildenv.sh .zefie/scripts/make.sh menuconfig
