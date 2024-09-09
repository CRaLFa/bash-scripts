#!/bin/bash

factorize () {
	local -i n="$1" i=2 c
	printf '%d = ' $n

	max=$(bc <<< "sqrt($n)")

	while (( i <= max ))
	do
		c=0

		while (( n % i == 0 ))
		do
			(( n /= i, c++ ))
		done

		if (( c < 1 )); then
			(( i++ ))
			continue
		elif (( c == 1 )); then
			printf '%d' $i
		else
			printf '%d^%d' $i $c
		fi

		(( n == 1 )) && {
			echo
			break
		}

		printf ' * '
		(( i++ ))
	done

	(( n > 1 )) && echo $n
}

main () {
	(( $# < 1 )) && {
		echo "Usage: $(basename "$0") INTEGER" >&2
		return 1
	}

	(( $1 < 2 )) && {
		echo 'INTEGER must be greater than 1.' >&2
		return 1
	}

	factorize $1
}

main "$@"
