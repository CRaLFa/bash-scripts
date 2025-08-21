#!/bin/bash

set -uo pipefail

check_dependency () {
	command -v pup &> /dev/null || {
		echo 'pup is required' >&2
		return 1
	}
	command -v parallel &> /dev/null || {
		echo 'parallel is required' >&2
		return 1
	}
	return 0
}

nikkei_average () {
	local html
	html=$(curl -s 'https://www.nikkei.com/markets/worldidx/chart/nk225/' | pup '#MAIN_CONTENTS .economic') || return
	[ -z "$html" ] && return
	local price=()
	price+=("$(echo "$html" | pup '.economic_value_now text{}' | tr -d '\n ')")
	price+=("$(echo "$html" | pup '.economic_balance_value text{}' | tr -d '\n ')")
	price+=("$(echo "$html" | pup '.economic_balance_percent text{}' | tr -d '\n ')")
	echo -e "日経平均株価\n${price[*]}\n"
}

stock_price () {
	local code="$1" html
	html=$(curl -s "https://finance.yahoo.co.jp/quote/${code}.T") || return
	[ -z "$html" ] && return
	pup 'h2.PriceBoard__name__166W text{}' <<< "$html"
	local price=()
	price+=("$(pup 'span.PriceBoard__price__1V0k span.StyledNumber__value__3rXW text{}' <<< "$html")")
	price+=("$(pup 'span.PriceChangeLabel__prices__30Ey > span.PriceChangeLabel__primary__Y_ut > span.StyledNumber__value__3rXW text{}' <<< "$html")")
	price+=("($(pup 'span.PriceChangeLabel__prices__30Ey > span.PriceChangeLabel__secondary__3BXI > span.StyledNumber__value__3rXW text{}' <<< "$html") %)")
	echo -e "${price[*]}\n"
}

main () {
	check_dependency || return
	local watch='false' cmdline=()
	[[ $# -gt 0 && "$1" = '-w' && "$2" =~ ^[0-9.]+$ ]] && {
		watch='true'
		cmdline+=("watch -n $2 -x bash -c '")
		shift 2
	}
	cmdline+=('nikkei_average')
	(( $# > 0 )) && {
		cmdline+=("& parallel -j 0 -k stock_price ::: $@")
		export -f stock_price
	}
	eval $watch && {
		cmdline+=("'")
		export -f nikkei_average
	}
	eval "${cmdline[*]}"
}

main "$@"
