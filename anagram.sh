#!/bin/bash

if (( $# < 1 )); then
    echo 'Usage: anagram WORD [count]' >&2
    exit 1
fi

count=$(( $# == 1 ? 1 : "$2" ))
chars=( $(echo -n "$1" | grep -o . | tr '\n' ' ') )

for (( i = 0; i < count; i++ ))
do
    shuf -e "${chars[@]}" | tr -d '\n'
    echo ''
done
