#!/bin/bash

DICT_DIR="$HOME/.dict"

if [ ! -d $DICT_DIR ]; then
    mkdir -p $DICT_DIR || exit $?
    echo -e 'Downloading dictionary...\n'
    curl -sS http://www.namazu.org/~tsuchiya/sdic/data/gene95.tar.gz \
        | tar xzOf - gene.txt \
        | nkf -Sw > $DICT_DIR/gene.txt || exit $?
fi

japanese=false
whole=false

while getopts 'jw' OPT
do
    case $OPT in
        j ) japanese=true ;;
        w ) whole=true ;;
        * ) exit 1 ;;
    esac
done

shift $(( OPTIND - 1 ))

if (( $# < 1 )); then
    echo 'Usage: dict [-jw] WORD' >&2
    exit 1
fi

cmdline=('grep -i --color=auto')

$japanese && cmdline+=('-B 1') || cmdline+=('-A 1')
$whole && cmdline+=('-w')

cmdline+=("'$1' $DICT_DIR/gene.txt")

eval "${cmdline[@]}"
