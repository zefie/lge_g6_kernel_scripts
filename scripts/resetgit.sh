#!/bin/bash
source .zefie/scripts/buildenv.sh

if [ -d ".git" ]; then
	if git diff-index --name-only HEAD | grep -qv "^scripts/package"; then
		if git diff-index --name-only HEAD | grep -qv "^.zefie"; then
			echo "Resetting source tree..."
			for f in $(ls . | grep -v "^${KERNEL_BUILDDIR}$"); do
				rm -rf "${f}"
			done;
			rm -f .config .config.old
			rm -rf "${KERNEL_BUILDDIR}/"*
			git reset --hard
		fi
	fi
fi
