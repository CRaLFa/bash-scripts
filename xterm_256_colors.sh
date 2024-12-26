#!/bin/bash

fg_color () {
	printf '\e[38;5;%dm\e[40m %3d' "$1" "$1"
}

bg_color () {
	printf '\e[37m\e[48;5;%dm %3d' "$1" "$1"
}

new_line () {
	printf '\e[0m\n'
}

main () {
	local -i c
	for c in {0..255}
	do
		(( (c <= 16 && c % 8 == 0) || (c > 16 && c % 6 == 4) )) && new_line
		(( c == 16 )) && new_line
		fg_color $c
		bg_color $c
	done
	new_line
}

main
