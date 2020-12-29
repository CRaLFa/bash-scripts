#!/bin/bash

if (( $# < 1 )); then
    echo "Usage: tomp3 EXTENSION (e.g. 'wav', 'flac')" >&2
    exit 1
fi

which rename &>/dev/null || exit $?
which ffmpeg &>/dev/null || exit $?

ext=$1
rename 's/ /€/g' *."$ext"

for file in $(ls *."$ext")
do
    ffmpeg -vn -i $file -ac 2 -ar 44100 -b:a 320k -acodec libmp3lame -f mp3 "${file%.*}.mp3"
done

rename 's/€/ /g' *
