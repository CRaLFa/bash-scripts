#!/bin/bash

set -euo pipefail

main () {
	local y from to holidays ym

	y=$(date '+%Y')
	from=$(( y * 100 + $(date '+%m') ))
	to=$from

	if [[ "$*" == *3* ]]; then
		from=$(( $(date -d '-1 month' '+%Y') * 100 + $(date -d '-1 month' '+%m') ))
		to=$(( $(date -d '+1 month' '+%Y') * 100 + $(date -d '+1 month' '+%m') ))
	elif [[ "$*" == *y* ]]; then
		from=$(( y * 100 + 1 ))
		to=$(( y * 100 + 12 ))
	fi

	holidays="$(curl -s 'https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv' | nkf -w -Lu | grep -E "$(( y - 1 ))|${y}|$(( y + 1 ))" | tr ',' '\t')"

	cal "$@"

	for (( ym = from; ym <= to; ym++ ))
	do
		grep "$(( ym / 100 ))/$(( ym % 100 ))/" <<< "$holidays" || true
	done
}

main "$@"
