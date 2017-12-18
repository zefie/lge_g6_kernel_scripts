#!/bin/bash
source .zefie/scripts/buildenv.sh

DEFCONFIG_DIR="arch/${ARCH}/configs"

cp -r .zefie/scripts/dtbTool scripts/

EXFAT_STATUS=m

if [ ! -z "${KERNEL_RECOVERY}" ]; then
	EXFAT_STATUS=y
fi

read -r -d '' CONFIG << EOM
# Melina Kernel Custom Config Options
CONFIG_LOCALVERSION="-${KERNEL_NAME}"
CONFIG_DRIVEDROID_CDROM=y

# exFAT
CONFIG_EXFAT_FS=${EXFAT_STATUS}
CONFIG_EXFAT_DISCARD=y
CONFIG_EXFAT_DELAYED_SYNC=y
CONFIG_EXFAT_KERNEL_DEBUG=n
CONFIG_EXFAT_DEBUG_MSG=n
CONFIG_EXFAT_DEFAULT_CODEPAGE=437
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8

# kcal
CONFIG_FB_MSM_MDSS_KCAL_CTRL=y

# Performance tweaks
CONFIG_DYNAMIC_FSYNC=y
CONFIG_CPU_INPUT_BOOST=y
CONFIG_CPU_FREQ_GOV_ELEMENTALX=y
CONFIG_CPU_FREQ_GOV_ZZMOOVE=y

# F2FS
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
CONFIG_F2FS_CHECK_FS=n
CONFIG_F2FS_FS_ENCRYPTION=y
CONFIG_F2FS_FAULT_INJECTION=n

# Wifi
CONFIG_BCMDHD_OEM_HEADER_PATH="${PWD}/drivers/net/wireless/bcmdhd_ext/include/wifi_bcm_lge.h"
EOM

if [ "${KERNEL_DEVMODEL}" == "H870" ]; then
read -r -d '' EXTRA_CONFIG << EOM
# H870 Wifi Override
CONFIG_BCMDHD_FOLLOW_AP_DTIM_PERIOD=n
CONFIG_BCMDHD_LEGACY=y
EOM

# Sound config
touch arch/arm64/boot/dts/lge/msm8996-lucye_sound_type/current_sound_type.dtsi
fi

if [ ! -z "${EXTRA_CONFIG}" ]; then
	CONFIG+="$(echo; echo "${EXTRA_CONFIG}";)"
fi

echo "*** Generating ${KERNEL_NAME} kernel defconfig..."
rm -f ${DEFCONFIG_DIR}/$${KERNEL_NAME}_zefiescripts_defconfig
cp -f ${DEFCONFIG_DIR}/${KERNEL_DEFCONFIG} ${DEFCONFIG_DIR}/${KERNEL_NAME}_zefiescripts_defconfig

if [ ! -z "${CONFIG}" ]; then
	echo "${CONFIG}" >> ${DEFCONFIG_DIR}/${KERNEL_NAME}_zefiescripts_defconfig
fi

make -C .zefie/lz4demo clean > /dev/null 2>&1
make -C .zefie/lz4demo
