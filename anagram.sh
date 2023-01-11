#!/bin/bash

if (( $# < 1 )); then
    echo "Usage: $(basename $0) WORD [count]" >&2
    exit 1
fi

declare -i count=$2
(( count == 0 && (count = 1) ))

yes "$1" | head -n $count | xargs -I @ bash -c 'echo "@" | grep -o . | shuf | paste -sd ""'
