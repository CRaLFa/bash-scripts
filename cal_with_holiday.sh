#!/bin/bash

main () {
	local y ym_from ym_to holidays

	y=$(date '+%Y')
	ym_from=$(( y * 100 + $(date '+%m') ))
	ym_to=$ym_from

	if [[ "$*" == *3* ]]; then
		ym_from=$(( $(date -d '-1 month' '+%Y') * 100 + $(date -d '-1 month' '+%m') ))
		ym_to=$(( $(date -d '+1 month' '+%Y') * 100 + $(date -d '+1 month' '+%m') ))
	elif [[ "$*" == *y* ]]; then
		ym_from=$(( y * 100 + 1 ))
		ym_to=$(( y * 100 + 12 ))
	fi

	holidays="$(curl -s 'https://www8.cao.go.jp/chosei/shukujitsu/syukujitsu.csv' | nkf -w -Lu | grep -E "$(( y - 1 ))|${y}|$(( y + 1 ))" | tr ',' '\t')"

	cal "$@"

	for (( ym = ym_from; ym <= ym_to; ym++ ))
	do
		grep "$(( ym / 100 ))/$(( ym % 100 ))" <<< "$holidays"
	done
}

main "$@"
