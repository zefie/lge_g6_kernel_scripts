#!/bin/bash
# Update this and uncomment it

#export TOOLCHAIN="/home/zefie/g6dev/toolchains/uber/out/aarch64-linux-android-6.x/bin/aarch64-linux-android-"
export KERNEL_NAME="melina" # please change from melina for custom builds
export KERNEL_DEVNAME="${USER}" # can be normal name, defaults to linux username ;)

export ANDROID_TARGET="STOCK" # Could be Lineage-14.0, or whatever. Just for zip name.
export KERNEL_BUILDDIR="build" # A subdirectory in this repo that is in .gitignore and doesn't already exist. Best just leave it be.

# These can be overridden by the env, using vars that replace DEFAULT_ with KERNEL_, ex: KERNEL_DEFCONFIG
export DEFAULT_MANU="LG" # for zip filename
export DEFAULT_MODEL="G6" # for zip filename
export DEFAULT_DEVMODEL="US997" # for zip filename, and anykernel whitelist (converted to lowercase for whitelist)
export DEFAULT_DEFCONFIG="lucye_nao_us-perf_defconfig" # device, check your build fingerprint

# Zefie Toolchain Layout
KERNEL_ZEFIE_TOOLCHAIN_LAYOUT=1 # You probably want this as 0
ZEFIE_TC_NAME="uber"
ZEFIE_TC_TYPE="aarch64-linux-android"
ZEFIE_TC_VER="6.x"


# Do not edit below this line

export PATH="${PWD}/.zefie/lz4demo:${PATH}"
export ARCH="arm64"
export KERNEL_COMPRESSION_SUFFIX="lz4"

# Allow env override
if [ -z "${TC_NAME}" ]; then export TC_NAME="${ZEFIE_TC_NAME}"; fi
if [ -z "${TC_TYPE}" ]; then export TC_TYPE="${ZEFIE_TC_TYPE}"; fi
if [ -z "${TC_VER}" ]; then export TC_VER="${ZEFIE_TC_VER}"; fi
if [ -z "${KERNEL_MANU}" ]; then export KERNEL_MANU="${DEFAULT_MANU}"; fi
if [ -z "${KERNEL_MODEL}" ]; then export KERNEL_MODEL="${DEFAULT_MODEL}"; fi
if [ -z "${KERNEL_DEVMODEL}" ]; then export KERNEL_DEVMODEL="${DEFAULT_DEVMODEL}"; fi
if [ -z "${KERNEL_DEFCONFIG}" ]; then export KERNEL_DEFCONFIG="${DEFAULT_DEFCONFIG}"; fi

if [ ${KERNEL_ZEFIE_TOOLCHAIN_LAYOUT} -eq 1 ]; then
	# Example toolchain path: /home/zefie/g6dev/toolchains/available/uber_aarch64-linux-android-6.x
	TC_ROOT="/home/${USER}/g6dev/toolchains/available"
	export TOOLCHAIN="${TC_ROOT}/${TC_NAME}_${TC_TYPE}-${TC_VER}/bin/${TC_TYPE}-"
fi

export CROSS_COMPILE="${TOOLCHAIN}"

if [ "$(basename $0)" == "buildenv.sh" ]; then
	if [ ! -z "$1" ]; then
		$@
	fi
fi

