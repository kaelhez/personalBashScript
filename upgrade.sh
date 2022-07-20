#!/bin/bash


# a script to update and upgrade the system
# AUR packages are included as well

if [ "$EUID" -ne 0 ]; then
	echo "root is required"
	neofetch --logo
	exit
fi

NORMUSER=$(who | awk 'NR==1{print $1;exit}')
echo "started at $(date)"

set -e

if [[ $# -gt 0 ]]; then
	case $1 in
		--confirmall|-cf)
			pacman -Syu --noconfirm
			sudo -H -u $NORMUSER bash -c 'paru -Syu --noconfirm'
			pacman -Scc -v --noconfirm
			sudo -H -u $NORMUSER bash -c 'paru -Sccd -v --noconfirm'
			;;
		*)
			echo "are you sure "$@" is valid?"
			echo "-cf|--confirmall = to skip the interactive mode."
			;;
	esac
exit
fi

read -n 1 -p "confirmation to upgrade all packages?[y/n]" PACK1
printf "\n"
read -n 1 -p "confirmation to clear all cache(AUR & Pacman)?[y/n]" PACK2
printf "\n"


if [[ $PACK1 =~ [Yy] ]] ; then
	pacman -Syu --noconfirm
	sudo -H -u $NORMUSER bash -c 'paru -Syu --noconfirm'
	clear
fi

if [[ $PACK2 =~ [Yy] ]] ; then
	sudo -H -u $NORMUSER bash -c 'paru -Sccd -v --noconfirm'
	pacman -Scc -v --noconfirm
fi


echo "exit code" $?
exit
