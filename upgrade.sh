#!/bin/bash
# a script to update and upgrade the system
# I made this script to speed up the process of updating and upgrading packages,
# AUR packages that is installed through paru will be updated and upgraded as well.
# ROOT is needed to run the most parts of this script

# more features and improvements could be implemented in this script

if [ "$EUID" -ne 0 ]; then
	echo 'root is required'
    if [ "$#" -ne 0 ]; then
      echo "su -c $1 or sudo $1"
    fi
    exit
fi


NORMUSER=$(who | awk 'NR==1{print $1;exit}')
echo "started at $(date)"

set -e

if [[ $# -gt 0 ]]; then
	case $1 in
		--confirmall|-ca)
			pacman -Syu --noconfirm
			sudo -H -u "$NORMUSER" bash -c 'paru -Syu --noconfirm'
			pacman -Scc -v --noconfirm
			sudo -H -u "$NORMUSER" bash -c 'paru -Sccd -v --noconfirm'
			;;
    --clean|-c)
      sudo -H -u "$NORMUSER" bash -c 'paru -Sccd -v --noconfirm'
      pacman -Scc -v --noconfirm
      ;;
    --overwrite|-ov)
      pacman -Syu --noconfirm --overwrite \*
			sudo -H -u "$NORMUSER" bash -c 'paru -Syu --noconfirm --overwrite \*'
			pacman -Scc -v --noconfirm --overwrite \*
			sudo -H -u "$NORMUSER" bash -c 'paru -Sccd -v --noconfirm --overwrite \*'
      ;;
		--help|-h)
      cat <<- 'EOF'
available commands:
-confirmall|-ca # skips the interactive mode
--clean|-c      # cleans the respective package manager's cache.
--overwrite|-ov # skips the interactive mode and conflict checks
EOF
      echo "usage:
$0 [-confirmall|-ca]
$0 [-clean|-c] 
$0 [--overwrite|-ov]
"
			;;
	*)
    echo "are you sure $1 is valid?"
	cat <<- 'EOF'
available commands:
-confirmall|-ca # skips the interactive mode
--clean|-c      # cleans the respective package manager's cache.
--overwrite|-ov # skips the interactive mode and conflict checks
EOF
      echo "usage:
$0 [-confirmall|-ca]
$0 [-clean|-c] 
$0 [--overwrite|-ov]
"

			;;
	esac
exit
fi

read -r -n 1 -p "confirmation to upgrade all packages?[y/n]" PACK1
printf "\n"
read -r -n 1 -p "confirmation to clear all cache(AUR & Pacman)?[y/n]" PACK2
printf "\n"
read -r -n 1 -p "confirmation to overwrite files(to bypass conflict checks)?[y/n]" PACK3
printf "\n"

if [[ $PACK1 =~ [Yy] ]] ; then
	pacman -Syu --noconfirm
	sudo -H -u "$NORMUSER" bash -c 'paru -Syu --noconfirm'
fi

if [[ $PACK2 =~ [Yy] ]] ; then
	sudo -H -u "$NORMUSER" bash -c 'paru -Sccd -v --noconfirm'
	pacman -Scc -v --noconfirm
fi

if [[ $PACK3 =~ [Yy] ]]; then
  sudo -H -u "$NORMUSER" bash -c 'paru -Syu -v --noconfirm --overwrite'
	pacman -Syu -v --noconfirm --overwrite

fi

echo "exit code" $?
exit
