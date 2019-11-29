#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    gpg="$( which gpg2 2>/dev/null || which gpg 2>/dev/null )"
else
    gpg="$1"
fi

if [ ! -z "${gpg}" ]; then
    git config --global gpg.program "${gpg}"
    git config --global commit.gpgsign "true"
else
    git config --global --delete gpg.program || true
    git config --global commit.gpgsign "false"
fi
