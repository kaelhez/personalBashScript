#!/bin/bash

help ()
{
  cat <<- EOF
script is best to run with ROOT
perms,
available commands:
-h|--help


usage:
EOF
echo "  sudo $(basename "$0") -h  # print this out "
echo "  sudo $(basename "$0") -c  # clear caches "
echo "  sudo $(basename "$0") -u  # update packages"

}


USER=$(who | awk 'NR==1{print $1;exit}')
# paru
updateparu ()
{
  sudo -H -u "$USER" bash -c 'paru -Syu --noconfirm'
}


clearparu ()
{
  sudo -H -u "$USER" bash -c 'paru -Sccd -v --noconfirm'
}

# pacman
updatepacman ()
{
  pacman -Syu --nocomfirm
}


clearpacman ()
{
  pacman -Sccd -v --noconfirm
}


UPDATEPKGS=
CLEARPKGS=

# parse args
while getopts ':huc' arg; do
  case "$arg" in
    u)
    UPDATEPKGS=1
    ;;
    c)
    CLEARPKGS=1
    ;;
    h)
    help
    exit 0
    ;;
    ?)
    printf 'an error occured, check your specified flags\n' 
    help
    exit 1
    ;;
  esac
done

if [[ $# -lt 1 ]]; then
  printf "not enough args!\n" 
  help
  exit 1
fi


if [[ "$UPDATEPKGS" ]]; then
  updatepacman
  updateparu
fi

if [[ "$CLEARPKGS" ]]; then
  clearpacman
  clearparu
fi


shift $(( OPTIND -1 ))
