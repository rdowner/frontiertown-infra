#!/usr/bin/env bash

zsh="$( grep zsh /etc/shells | head -1 )"

function config_user() {
    u=$1
    cursh="$( getent passwd $u | cut -d: -f7 )"
    [ "${cursh}" = "${zsh}" ] && return
    sudo chsh -s "${zsh}" "${u}"
    home="$( getent passwd $u | cut -d: -f6)"
    [ -d "${home}/.oh-my-zsh" ] || return
    cp ~/.zshrc "${home}/.zshrc"
    cp ~/.zshenv "${home}/.zshenv"
    cp ~/.zprofile "${home}/.zprofile"
    chown $u:$u "${home}/.zshrc" "${home}/.zshenv" "${home}/.zshprofile"
}

for user in $( getent passwd | cut -d: -f1 ); do
    for group in $( id -nG $user ); do
        case $group in
            users|wheel|admin|sudo)
                config_user $user
                break
                ;;
        esac
    done
done
