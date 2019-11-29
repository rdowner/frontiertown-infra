#!/usr/bin/env bash

set -e

winprofile="$( wslpath "$1" )"
test -d "${winprofile}" || exit 1
if [ -e "${winprofile}/.git-credentials" ]; then
    rm "${HOME}/.git-credentials" || true
    ln -s "${winprofile}/.git-credentials" "${HOME}/.git-credentials"
fi
