#!/bin/bash

which node > /dev/null 2>&1 || exit $?

length=20
upper=0

while getopts 'hl:u' OPT
do
    case $OPT in
        h) echo 'Usage: pwgen [-l LENGTH] [-u]' && exit 0 ;;
        l) length=$OPTARG ;;
        u) upper=1 ;;
        *) exit 1 ;;
    esac
done

passwd=$(node -e "console.log(Math.random().toString(36).substr(2, $length));")

(( upper == 1 )) && echo ${passwd^^} || echo $passwd
