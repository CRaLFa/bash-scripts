#!/bin/bash

shuf_str () {
    echo "$1" | grep -o . | shuf | paste -sd ''
}

main () {
    (( $# < 1 )) && {
        echo "Usage: $(basename "$0") WORD [COUNT]" >&2
        return 1
    }

    local -i cnt=${2:-1}
    export -f shuf_str

    yes "$1" | head -n $cnt | xargs -P 0 -I @ bash -c 'shuf_str "@"'
}

main "$@"
