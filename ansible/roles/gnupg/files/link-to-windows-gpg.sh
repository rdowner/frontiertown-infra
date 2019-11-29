#!/usr/bin/env bash

set -e

gpgdir="$( dirname "$1")"
for exe in "${gpgdir}"/*.exe; do
    local="${HOME}/.local/bin/$( basename "${exe}" .exe )"
    [ -e "${local}" ] && rm "${local}"
    ln -s "${exe}" "${local}"
done
