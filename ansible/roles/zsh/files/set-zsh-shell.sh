#!/usr/bin/env bash

set -e

curl -fsSL -o/tmp/install-oh-my-zsh.sh https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh

getgroupmembers() {
    if [[ $# != 1 || $1 == -* || $1 =~ [[:space:]] ]]; then
        echo "Usage: ${0##*/} groupname" >&2
        echo "Lists all members of the group." >&2
        return 64
    fi
    the_group="$1"

    if which >/dev/null 2>/dev/null dsmemberutil; then
        if (dsmemberutil checkmembership -U root -G "$the_group" 2>&1 | grep -q "group .* cannot be found") >&2; then
            return
        fi

        exec dscl . -list /Users | while read each_username
        do
            printf "$each_username "
            dsmemberutil checkmembership -U "$each_username" -G "$the_group"
        done | grep "is a member" | cut -d " " -f 1
    else
        getent group $g | cut -d: -f4 | tr , ' '
    fi
}
getusershell() {
    if which >/dev/null 2>/dev/null dscl; then
        dscl . -read /Users/$1 UserShell | cut -c12-
    else
        getent passwd $1 | cut -d: -f7
    fi
}
getuserhome() {
    if which >/dev/null 2>/dev/null dscl; then
        dscl . -read /Users/$1 NFSHomeDirectory | cut -c19-
    else
        getent passwd $1 | cut -d: -f6
    fi
}
getuserprimarygroupid() {
    if which >/dev/null 2>/dev/null dscl; then
        dscl . -read /Users/$1 PrimaryGroupID | cut -c 17-
    else
        getent passwd $1 | cut -d: -f4
    fi
}

zsh="$( grep zsh /etc/shells | head -1 )"
copyfromuser=$1
if [ -z "${copyfromuser}" ]; then
    echo >&2 "Command line missing argument: username to copy ZSH config from"
    exit 1
fi
configfiles="$( getuserhome "${copyfromuser}" )"
groups_to_check="users wheel admin sudo"
users="root $(for g in ${groups_to_check}; do getgroupmembers $g; done)"
users_dedup="$( echo $users | tr ' ' '\n' | sort | uniq | tr '\n' ' ' )"
echo "Installing for users: $users_dedup"
for u in $users_dedup; do
    cursh="$( getusershell "${u}" )"
    [ "${cursh}" = "${zsh}" ] || (
        echo "Setting shell of user $u"
        chsh -s "${zsh}" "${u}";
    )
    home="$( getuserhome "${u}" )"
    [ -d "${home}/.oh-my-zsh" ] || (
        echo "Install oh-my-zsh for user $u"
        su -l "${u}" -c "echo exit | sh /tmp/install-oh-my-zsh.sh"
    )
    if [ "${copyfromuser}" '!=' "${u}" ]; then
        cp "${configfiles}/.zshrc" "${home}/.zshrc"
        cp "${configfiles}/.zshenv" "${home}/.zshenv"
        cp "${configfiles}/.zprofile" "${home}/.zprofile"
        chown $u:$( getuserprimarygroupid "${u}" ) "${home}/.zshrc" "${home}/.zshenv" "${home}/.zprofile"
    fi
done
