#!/bin/bash
if [ -d ".git" ]; then
	if git diff-index --name-only HEAD | grep -qv "^scripts/package"; then
		if git diff-index --name-only HEAD | grep -qv "^.zefie"; then
			echo "Resetting source tree..."
			rm * .config .config.old -rf
			git reset --hard
		fi
	fi
fi
