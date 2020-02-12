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

setenv AWS_VAULT_BACKEND pass
