#!/bin/bash

main () {
	command -v ffmpeg &> /dev/null || {
		echo 'ffmpeg is required' >&2
		return
	}

	while read -r f
	do
		ffmpeg -vn -i "$f" -ac 2 -ar 44100 -b:a 320k -acodec libmp3lame -f mp3 "${f%.*}.mp3"
	done < <(find . -type f -regextype posix-extended -regex '.+\.(wav|flac)')
}

main "$@"
