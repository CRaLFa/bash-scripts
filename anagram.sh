#!/bin/bash

if (( $# < 1 )); then
    echo 'Usage: anagram WORD [count]' >&2
    exit 1
fi

declare -i arg2=$2
count=$(( $# == 1 ? 1 : arg2 ))

chars=( $(echo $1 | grep -o . | tr '\n' ' ') )

for (( i = 0; i < count; i++ ))
do
    shuf -e ${chars[@]} | tr -d '\n'
    echo ''
done
