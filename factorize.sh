#!/bin/bash

if (( $# < 1 )); then
    echo 'Usage: bfactor INTEGER' >&2
    exit 1
fi

declare -i n=$1 i=2 c
max=$(awk -v num=$n 'BEGIN { printf "%d", sqrt(num) }')
printf '%d = ' $n

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

    if (( n == 1 )); then
        echo ''
        break
    fi

    printf ' * '
    (( i++ ))
done

(( n > 1 )) && echo $n
