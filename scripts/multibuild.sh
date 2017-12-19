#!/bin/bash
MODELS="US997 H870"
for m in ${MODELS}; do
	.zefie/scripts/do_kernel_build.sh $m
	RC=$?
	if [ $RC -ne 0 ]; then
		exit $RC
	fi
done
