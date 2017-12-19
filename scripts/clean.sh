#!/bin/bash
source .zefie/scripts/buildenv.sh
rm -rf "${KERNEL_BUILDDIR}"/*
.zefie/scripts/resetgit.sh
.zefie/scripts/prepare.sh
.zefie/scripts/mrproper.sh
.zefie/scripts/defconfig.sh

