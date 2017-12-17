#!/bin/bash
if [ -d ".git" ]; then
	GIT_STATUS=$(git status --ignore-submodules=dirty)
	if [ "$(echo "${GIT_STATUS}" | grep 'modified:' | wc -l)" -gt "0" ] || [ "$(echo "${GIT_STATUS}" | grep "Untracked" | wc -l)" -gt "0" ] || [ ! -z "${FORCE_RESET}" ]; then
		echo "Resetting source tree..."
		rm * .config .config.old -rf
		git reset --hard
	fi
fi
