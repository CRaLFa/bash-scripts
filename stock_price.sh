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
    local code="$1"
    local html=$(curl -s "https://finance.yahoo.co.jp/quote/${code}.T")
    [ -z "$html" ] && return
    pup 'h2.PriceBoardMain__name__6uDh text{}' <<< "$html"
    local price=()
    price+=($(pup 'span.PriceBoardMain__price__1mwP span.StyledNumber__value__3rXW text{}' <<< "$html"))
    price+=($(pup 'span.PriceChangeLabel__prices__30Ey > span.PriceChangeLabel__primary__Y_ut > span.StyledNumber__value__3rXW text{}' <<< "$html"))
    price+=("($(pup 'span.PriceChangeLabel__prices__30Ey > span.PriceChangeLabel__secondary__3BXI > span.StyledNumber__value__3rXW text{}' <<< "$html") %)")
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
        cmdline+=("watch -n $2")
        shift 2
    }
    cmdline+=("parallel -j 0 -k stock_price ::: $@")
    export -f stock_price
    eval ${cmdline[@]}
}

main "$@"
