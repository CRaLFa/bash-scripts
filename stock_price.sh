#!/bin/bash

stock_price () {
    local code html price
    for code in "$@"
    do
        html=$(curl -s "https://finance.yahoo.co.jp/quote/${code}.T")
        [ -z "$html" ] && continue
        pup 'h2._6uDhA-ZV text{}' <<< "$html"
        price=()
        price+=($(pup 'span._1mwPgJ2S span._3rXWJKZF text{}' <<< "$html"))
        price+=($(pup 'span._30Ey7Bcp > span.Y_utZE_b > span._3rXWJKZF text{}' <<< "$html"))
        price+=("($(pup 'span._30Ey7Bcp > span._3BXIqAcg > span._3rXWJKZF text{}' <<< "$html") %)")
        echo -e "${price[@]}\n"
    done
}

main () {
    (( $# < 1 )) && {
        echo "Usage: $(basename $0) [-w INTERVAL] STOCK_CODE..." >&2
        return
    }
    local cmdline=()
    [[ "$1" = '-w' && "$2" =~ ^[0-9.]+$ ]] && {
        local -i interval=$2
        cmdline+=(watch -n $interval)
        export -f stock_price
        shift 2
    }
    cmdline+=(stock_price "$@")
    eval ${cmdline[@]}
}

main "$@"
