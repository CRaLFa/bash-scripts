#!/bin/bash

main () {
	(( $# < 1 )) && {
		echo "Usage: $(basename "$0") EXTENSION (e.g. 'wav', 'flac')" >&2
		return 1
	}

	which ffmpeg &> /dev/null || {
		echo 'ffmpeg is required' >&2
		return
	}

	for file in ./*."$1"
	do
		ffmpeg -vn -i "$file" -ac 2 -ar 44100 -b:a 320k -acodec libmp3lame -f mp3 "${file%.*}.mp3"
	done
}

main "$@"
