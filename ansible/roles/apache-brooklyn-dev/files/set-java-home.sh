#!/usr/bin/env bash

javac="$( which javac )"
while [ -L "${javac}" ]
do
    javac="$( dirname "${javac}" )/$( readlink "${javac}" )"
done
javabin="$( dirname "${javac}" )"
javahome="$( dirname "${javabin}" )"
while [[ $javahome =~ ([^/][^/]*/\.\./) ]]
do
    javahome=${javahome/${BASH_REMATCH[0]}/}
done
echo "export JAVA_HOME=\"${javahome}\"" | sudo tee /etc/profile.d/set-java-home
