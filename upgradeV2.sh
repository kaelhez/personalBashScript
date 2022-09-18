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
echo "  sudo $(basename "$0") -p  # optional params. eg: --overwrite,etc"

}


set -e

USER=$(who | awk 'NR==1{print $1;exit}')
# paru
updatepkg ()
{
  sh -c "pacman -Syu --noconfirm $*"
  sudo -H -u "$USER" bash -c "paru -Syu --noconfirm"
}


clrpkg ()
{
  sh -c "pacman -Sccd -v --noconfirm $*"
  sudo -H -u "$USER" bash -c "paru -Sccd -v --noconfirm"
}


UPDATEPKGS=
CLEARPKGS=
PARAM=()

# parse args
while getopts ':hucp:' arg; do
  case "$arg" in
    u)
    UPDATEPKGS=1
    ;;
    c)
    CLEARPKGS=1
    ;;
    p)
    PARAM+=("$OPTARG")
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
  updatepkg "${PARAM[@]}"
elif [[ "$CLEARPKGS" ]]; then
  clrpkg "${PARAM[@]}"
fi

if [[ -n "${PARAM[*]}" ]]; then
  echo "optional params ${PARAM[*]}"
fi


shift $(( OPTIND -1 ))

exit $?
