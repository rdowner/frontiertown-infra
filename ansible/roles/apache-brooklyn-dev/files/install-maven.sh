#!/usr/bin/env bash

archive="$( mktemp -t tmp.XXXXXXXXXX.tar.gz )"
function finish() { rm "${archive}"; }
trap finish EXIT

version=3.6.3
url=https://dist.apache.org/repos/dist/release/maven/maven-3/${version}/binaries/apache-maven-${version}-bin.tar.gz
dest=/usr/local/share
mhome="${dest}/apache-maven-${version}"

wget -O "${archive}" "${url}"
sudo tar -C "${dest}" -xzf "${archive}"
[ -e /usr/local/bin/mvn ] && sudo rm /usr/local/bin/mvn
sudo ln -s "${mhome}/bin/mvn" /usr/local/bin/mvn

echo "export MAVEN_HOME=\"${mhome}\"" | sudo tee /etc/profile.d/apache-maven.sh
