#!/bin/bash -x

main () {
	command -v ffmpeg &> /dev/null || {
		echo 'ffmpeg is required' >&2
		return
	}

	while read -r f
	do
		ffmpeg -nostdin -i "$f" -c:a libmp3lame -b:a 320k -ac 2 -ar 44100 -c:v copy -id3v2_version 3 "${f%.*}.mp3"
	done < <(find . -maxdepth 1 -type f -regextype posix-extended -regex '.+\.(wav|flac)')
}

main "$@"
