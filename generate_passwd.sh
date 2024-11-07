#!/bin/bash

usage () {
	echo "Usage: $(basename "$0") [-h|--help] [-l|--lower] [-u|--upper] [length]" >&2
}

main () {
	local args lower='false' upper='false'

	args=$(getopt -o 'hlu' -l 'help,lower,upper' -- "$@") || {
		usage
		return 1
	}
	eval "set -- $args"

	while (( $# > 0 ))
	do
		case "$1" in
			-h|--help)
				usage
				return 0
			;;
			-l|--lower)
				lower='true'
			;;
			-u|--upper)
				upper='true'
			;;
			--)
				shift
				break
			;;
		esac
		shift
	done

	local rand_str=$(base64 /dev/random | head | paste -sd '')
	local -i len=${1:-10}
	local pw=${rand_str:0:$len}

	eval $lower && pw=${pw,,}
	eval $upper && pw=${pw^^}

	echo "$pw"
}

main "$@"
