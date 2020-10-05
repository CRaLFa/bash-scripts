#!/bin/bash

if (( $# < 1 )); then
    echo -e "Usage: tomp3 EXTENSION (e.g. 'wav', 'flac')" >&2
    exit 1
fi

which rename > /dev/null || exit 1
which ffmpeg > /dev/null || exit 1

ext=$1
rename 's/ /€/g' *."$ext"

for file in $(ls *."$ext")
do
    title="${file%.*}"
    ffmpeg -vn -i "$file" -ac 2 -ar 44100 -b:a 320k -acodec libmp3lame -f mp3 "${title}.mp3"
done

rename 's/€/ /g' *
