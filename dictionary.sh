#!/bin/bash

[ -f /opt/gene95/gene.txt ] || exit $?

reverse=false
whole=false

while getopts 'rw' OPT
do
    case $OPT in
        r ) reverse=true ;;
        w ) whole=true ;;
        * ) exit 1 ;;
    esac
done

shift $(( OPTIND - 1 ))

if (( $# < 1 )); then
    echo 'Usage: dict [-rw] WORD' >&2
    exit 1
fi

commands=('grep -i')

$reverse && commands+=('-B 1') || commands+=('-A 1')
$whole && commands+=('-w')

commands+=("$1 /opt/gene95/gene.txt")

eval "${commands[@]}"
