#!/bin/bash

help ()
{
  local basenm
  basenm=$(basename "$0")
  cat <<- EOF
script is best to run with ROOT
perms,
available commands:
-h|--help


usage:
EOF
echo "  sudo $basenm -h # print this out "
echo "  sudo $basenm -c  # clear caches "
echo "  sudo $basenm -u  # update packages"
echo "  sudo $basenm -p  # optional params. eg: --overwrite,etc"
echo "  sudo $basenm -f  # quiet, no interactive yes/no questions, take caution if this was enabled"

}


set -e

USER=$(who | awk 'NR==1{print $1;exit}')


updatepkg ()
{
  sh -c "pacman -Syu  $*"
  sudo -H -u "$USER" bash -c "paru -Syu $*"
}


clrpkg ()
{
  sh -c "pacman -Sccd -v $*"
  sudo -H -u "$USER" bash -c "paru -Sccd -v $*"
}


UPDATEPKGS=
CLEARPKGS=
FORCE=
PARAM=()

# parse args
while getopts ':hucfp:' arg; do
  case "$arg" in
    u)
    UPDATEPKGS=1
    ;;
    c)
    CLEARPKGS=1
    ;;
    p)
    PARAM+=("$OPTARG") # add optarg each loop in an array
    ;;
    f)
    FORCE=1
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
  if [[ "$FORCE" ]]; then
    echo "force mode is enabled for system updating/upgrading"
    updatepkg "--noconfirm" "${PARAM[@]}"
  else
    updatepkg "${PARAM[@]}"
  fi
fi

if [[ "$CLEARPKGS" ]]; then
  if [[ "$FORCE" ]]; then
    echo "force mode is enabled for cache clearing"
    yes | clrpkg "${PARAM[@]}"
  else
    clrpkg "${PARAM[@]}"
  fi
fi

if [[ -n "${PARAM[*]}" ]]; then
  echo "optional params ${PARAM[*]}"
fi


shift $(( OPTIND -1 ))

exit $?
