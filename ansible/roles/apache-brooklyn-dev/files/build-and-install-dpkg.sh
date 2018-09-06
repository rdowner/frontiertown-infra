#!/usr/bin/env bash

dpkg_version=1.18.25

workdir="$( mktemp --directory )"
if [[ -z "${workdir}" -o '!' -d "${workdir}" ]]; then
    echo >&2 could not create temporary directory
    exit 1
fi
function finish {
  rm -rf "${workdir}"
}
trap finish EXIT

set -e

cd "${workdir}"
wget http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_${dpkg_version}.tar.xz
tar xJf dpkg_${dpkg_version}.tar.xz
cd dpkg_${dpkg_version}
./configure
make
make install
