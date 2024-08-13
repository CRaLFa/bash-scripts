#!/bin/bash

check_dependency () {
    which pup &> /dev/null || {
        echo 'pup is required' >&2
        return 1
    }
    which parallel &> /dev/null || {
        echo 'parallel is required' >&2
        return 1
    }
    return 0
}

stock_price () {
    local code="$1" html price
    html=$(curl -s "https://finance.yahoo.co.jp/quote/${code}.T")
    [ -z "$html" ] && return
    pup 'h2._6uDhA-ZV text{}' <<< "$html"
    price=()
    price+=($(pup 'span._1mwPgJ2S span._3rXWJKZF text{}' <<< "$html"))
    price+=($(pup 'span._30Ey7Bcp > span.Y_utZE_b > span._3rXWJKZF text{}' <<< "$html"))
    price+=("($(pup 'span._30Ey7Bcp > span._3BXIqAcg > span._3rXWJKZF text{}' <<< "$html") %)")
    echo -e "${price[@]}\n"
}

main () {
    (( $# < 1 )) && {
        echo "Usage: $(basename $0) [-w INTERVAL] STOCK_CODE..." >&2
        return
    }
    check_dependency || return
    local cmdline=()
    [[ "$1" = '-w' && "$2" =~ ^[0-9.]+$ ]] && {
        local -i interval=$2
        cmdline+=("watch -n $interval")
        shift 2
    }
    cmdline+=("parallel -j 0 -k stock_price ::: $@")
    export -f stock_price
    eval ${cmdline[@]}
}

main "$@"
