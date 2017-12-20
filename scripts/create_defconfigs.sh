#!/bin/bash
source .zefie/scripts/buildenv.sh

DEFCONFIG_DIR="arch/${ARCH}/configs"
ORIG_DEFCONFIG="lucye_nao_us-perf_defconfig" # Yes even for variants. We override with melina_model_subconfig

# If you would like to add custom config easily without breaking melina build system, add it here then
# run this script to get your custom defconfig with melina additions.
# This can also override melina additions by setting the config value to n

read -r -d '' CUSTOM_CONFIG << EOM
# Add custom config below here, above EOM line

EOM


### Do not edit below this line ###

if [ ! -z "${KERNEL_RECOVERY}" ]; then
read -r -d '' EXTRA_CONFIG << EOM
# exFAT built in for recovery kernel
CONFIG_EXFAT_FS=y
CONFIG_EXFAT_DELAYED_SYNC=n

# NTFS read only support for recovery kernel
CONFIG_NTFS_FS=y

EOM
fi

for m in ${SUPPORTED_MODELS}; do
	DEVMODEL_LOWER="$(echo "$m" | tr '[:upper:]' '[:lower:]')"
	TARGET_FILE="${DEFCONFIG_DIR}/${KERNEL_NAME_LOWER}_${DEVMODEL_LOWER}_defconfig"
	echo "*** Generating ${KERNEL_NAME}_${DEVMODEL_LOWER} kernel defconfigs..."
	rm -f "${TARGET_FILE}"
	cp -f "${DEFCONFIG_DIR}/${ORIG_DEFCONFIG}" "${TARGET_FILE}"
	if [ -z "${KERNEL_RECOVERY}" ]; then
		echo "CONFIG_LOCALVERSION=\"-${KERNEL_NAME_LOWER}\"" >> "${TARGET_FILE}"
	else
		echo "CONFIG_LOCALVERSION=\"-${KERNEL_NAME_LOWER}-recovery\"" >> "${TARGET_FILE}"
	fi
	cat "${DEFCONFIG_DIR}/melina_common_subconfig" >> "${TARGET_FILE}"
	if [ -f "${DEFCONFIG_DIR}/melina_${DEVMODEL_LOWER}_subconfig" ]; then
		cat "${DEFCONFIG_DIR}/melina_${DEVMODEL_LOWER}_subconfig" >> "${TARGET_FILE}"
	fi

	if [ ! -z "${EXTRA_CONFIG}" ]; then
		echo "${EXTRA_CONFIG}" >> "${TARGET_FILE}"
	fi
	echo "${CUSTOM_CONFIG}" >> "${TARGET_FILE}"
done
