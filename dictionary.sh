#!/bin/bash

DICT_DIR="$HOME/.dict"

if [ ! -f $DICT_DIR/gene.txt ]; then
    mkdir -p $DICT_DIR || exit $?
    echo -e 'Downloading dictionary...\n'
    curl -sS http://www.namazu.org/~tsuchiya/sdic/data/gene95.tar.gz \
        | tar xzOf - gene.txt \
        | nkf -Sw > $DICT_DIR/gene.txt || exit $?
fi

print_help () {
    cat << _EOT_
Usage: $(basename $0) [OPTION]... SEARCH_WORD

English-Japanese dictionary for Bash

Options:
    -h, --help          display this help and exit
    -j, --japanese      recognize SEARCH_WORD as Japanese
    -w, --whole         match only whole SEARCH_WORD
_EOT_
}

OPTIONS=$(getopt -o 'hjw' -l 'help,japanese,whole' -- "$@") || {
    print_help | head -n 1 >&2
    exit 1
}

eval "set -- $OPTIONS"

japanese=false
whole=false

while (( $# > 0 ))
do
    case "$1" in
        -h | --help )
            print_help
            exit 0
            ;;
        -j | --japanese )
            japanese=true
            ;;
        -w | --whole )
            whole=true
            ;;
        -- )
            shift
            break
            ;;
    esac
    shift
done

if (( $# < 1 )); then
    print_help | head -n 1 >&2
    exit 1
fi

cmdline=('grep -i --color=auto')

if $japanese; then
    cmdline+=('-B 1')
else
    cmdline+=('-A 1')
fi

if $whole; then
    cmdline+=('-w')
fi

cmdline+=("'$1' $DICT_DIR/gene.txt")

eval "${cmdline[@]}"
