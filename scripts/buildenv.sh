#!/bin/bash

# git clone https://github.com/zefie/binary_toolchains -b uber-6.x-x86_64-aarch64
export TOOLCHAIN="/home/zefie/ubertc/out/aarch64-linux-android-6.x/bin/aarch64-linux-android-"
export TOOLCHAIN32="/home/zefie/ubertc/out/arm-linux-androideabi-6.x/bin/arm-linux-androideabi-"

if [ ! -z "${WORKSPACE}" ]; then
	# Custom for Jenkins integration
	if [ "${JOB_BASE_NAME}" != "lg-g6-kernel" ]; then
		# todo: fix inline
		echo "not supported"
		exit 1;
	else
		export TOOLCHAIN="${WORKSPACE}/ubertc/aarch64-linux-android-6.x/bin/aarch64-linux-android-"
		export TOOLCHAIN32="${WORKSPACE}/ubertc/arm-linux-androideabi-6.x/bin/arm-linux-androideabi-"
	fi
fi

export KERNEL_NAME="MelinaReborn" # please change from Melina for custom builds
export KERNEL_DEVNAME="${USER}" # can be normal name, defaults to linux username ;)

export ANDROID_TARGET="AOSP" # Could be Lineage-14.0, or whatever. Just for zip name.
export KERNEL_BUILDDIR="build" # A subdirectory in this repo that is in .gitignore and doesn't already exist. Best just leave it be.

# These can be overridden by the env, using vars that replace DEFAULT_ with KERNEL_, ex: KERNEL_DEVMODEL
export DEFAULT_MANU="LG" # for zip filename
export DEFAULT_MODEL="G6" # for zip filename
export DEFAULT_DEVMODEL="US997" # for zip filename, and anykernel whitelist (converted to lowercase for whitelist)


# Do not edit below this line

export SUPPORTED_MODELS=("US997" "H870" "H872")
export PATH="${PWD}/.zefie/lz4demo:${PATH}"
export ARCH="arm64"
export DEFCONFIG_DIR="arch/${ARCH}/configs"
KERNEL_NAME_LOWER="$(echo "${KERNEL_NAME}" | tr '[:upper:]' '[:lower:]')"
export KERNEL_NAME_LOWER

# Allow env override
if [ -z "${TC_NAME}" ]; then export TC_NAME="${ZEFIE_TC_NAME}"; fi
if [ -z "${TC_TYPE}" ]; then export TC_TYPE="${ZEFIE_TC_TYPE}"; fi
if [ -z "${TC_VER}" ]; then export TC_VER="${ZEFIE_TC_VER}"; fi
if [ -z "${KERNEL_MANU}" ]; then export KERNEL_MANU="${DEFAULT_MANU}"; fi
if [ -z "${KERNEL_MODEL}" ]; then export KERNEL_MODEL="${DEFAULT_MODEL}"; fi
if [ -z "${KERNEL_DEVMODEL}" ]; then export KERNEL_DEVMODEL="${DEFAULT_DEVMODEL}"; fi
KERNEL_DEVMODEL_LOWER="$(echo "${KERNEL_DEVMODEL}" | tr '[:upper:]' '[:lower:]')"
export KERNEL_DEVMODEL_LOWER

export CROSS_COMPILE="${TOOLCHAIN}"
export CROSS_COMPILE_ARM32="${TOOLCHAIN32}"

if [ "$(basename "${0}")" == "buildenv.sh" ]; then
	if [ ! -z "$1" ]; then
		"${@}"
	fi
fi

