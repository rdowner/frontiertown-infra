#!/usr/bin/env bash

curl -fsSL -o/tmp/install-oh-my-zsh.sh https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh

zsh=/bin/zsh
groups_to_check="users wheel admin sudo"
users="root $(for g in ${groups_to_check}; do getent group $g | cut -d: -f4 | tr , ' '; done)"
users_dedup="$( echo $users | tr ' ' '\n' | sort | uniq | tr '\n' ' ' )"
echo "Testing users $users_dedup"
for u in $users_dedup; do
    cursh="$( getent passwd pi | cut -d: -f7 )"
    [ "${cursh}" = "${zsh}" ] || (
        echo "Setting shell of user $u"
        chsh -s "${zsh}" $u;
    )
    home="$( getent passwd $u | cut -d: -f6)"
    [ -d "${home}/.oh-my-zsh" ] || (
        echo "Install oh-my-zsh for user $u"
        su -l -c "echo exit | sh /tmp/install-oh-my-zsh.sh" $u
    )
done
