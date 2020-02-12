#!/usr/bin/env bash

set -e

function setenv() {
    varname=$1
    varvalue=$2
    envfile="${HOME}/.zshenv.local"

    if [ -e "${envfile}" ] && grep --quiet -E "^export ${varname}=" "${envfile}"; then
        sed -i~ -E "s|^export ${varname}=.*$|export ${varname}=\"${varvalue}\"|" "${envfile}"
    else
        echo "export ${varname}=\"${varvalue}\"" >> "${envfile}"
    fi

}

function link_to_windows_file() {
    winfile="${winprofile}/$1"
    wslfile="${HOME}/$1"

    if [ -e "${winfile}" ]; then
        rm "${wslfile}" || true
        ln -s "${winfile}" "${wslfile}"
    fi
}

winprofile="$( wslpath "$1" )"
test -d "${winprofile}" || exit 1

PASSWORD_STORE_DIR="${winprofile}/.password-store"
if [ -e "${PASSWORD_STORE_DIR}" ]; then
    setenv PASSWORD_STORE_DIR "${PASSWORD_STORE_DIR}"
    setenv AWS_VAULT_PASS_PASSWORD_STORE_DIR "${PASSWORD_STORE_DIR}"
fi

link_to_windows_file ".aws/config"
