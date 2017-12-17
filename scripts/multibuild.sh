#!/bin/bash
PRESET_BUILDS="US997 H870"
OUT_DIRECTORY="../lg_out"

for f in ${PRESET_BUILDS}; do
	export PRESET="${f}"
	echo "Building for ${PRESET}..."
	.zefie/scripts/cleanbuild.sh
	.zefie/scripts/buildzip.sh
	mv build/out/*.zip "${OUT_DIRECTORY}"
done

ls -l "${OUT_DIRECTORY}"/*.zip


