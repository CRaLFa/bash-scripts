#!/bin/bash

which node &> /dev/null || exit $?

length=20
upper=false

while getopts 'hl:u' OPT
do
    case $OPT in
        h) echo 'Usage: pwgen [-l LENGTH] [-u]' && exit 0 ;;
        l) length=$OPTARG ;;
        u) upper=true ;;
        *) exit 1 ;;
    esac
done

passwd=$(node -e "console.log(Math.random().toString(36).substr(2, $length));")

$upper && echo ${passwd^^} || echo $passwd
