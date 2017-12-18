LG_OUT_DIRECTORY="../lg_out"

if [ ! -z "${1}" ]; then
	export KERNEL_DEVMODEL="${1}"
	if [ ! -z "${2}" ]; then
		export KERNEL_DEFCONFIG="${2}_defconfig"
	fi
	MODELL=$(echo "${1}" | tr '[:upper:]' '[:lower:]');
	KERNLOG="${LG_OUT_DIRECTORY}/kernel-${MODELL}.log"
	ZIPLOG="${LG_OUT_DIRECTORY}/buildzip-${MODELL}.log"
	ZIPLOGD="${LG_OUT_DIRECTORY}/buildzip_details-${MODELL}.log"
	if [ $(ls -l ${LG_OUT_DIRECTORY}/*-${MODELL}.log | wc -l) -gt 0 ]; then
		echo "* Cleaning old ${1} log files..."
		rm ${LG_OUT_DIRECTORY}/*-${MODELL}.log
	fi
	echo "* Building ${1} kernel (log in ${KERNLOG})"
	.zefie/scripts/cleanbuild.sh > "${KERNLOG}" 2>&1
	echo "* Building ${1} zip (log in ${ZIPLOG})"
	.zefie/scripts/buildzip.sh > "${ZIPLOG}" 2>&1
	cp build/out/buildzip.log "${ZIPLOGD}"
	ZIPNAME=$(tail -n3 "${ZIPLOGD}" | grep Generated | cut -d' ' -f2 | rev | cut -d'/' -f1 | rev)
	if [ -f "build/out/${ZIPNAME}" ]; then
	        cp "build/out/${ZIPNAME}" "${LG_OUT_DIRECTORY}"/
		echo "* Successfully built ${ZIPNAME}"
	else
		echo "* Zip not found, check the logs to see what went wrong"
		ls -l ${LG_OUT_DIRECTORY}/*.log
	fi
else
	echo "Usage: ${0} MODEL [conf]"
	exit 1
fi

