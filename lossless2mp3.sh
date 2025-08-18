#!/bin/bash -x

main () {
	command -v ffmpeg &> /dev/null || {
		echo 'ffmpeg is required' >&2
		return
	}

	while read -r f
	do
		ffmpeg -nostdin -i "$f" -ac 2 -ar 44100 -b:a 320k -acodec libmp3lame -c:v copy -f mp3 "${f%.*}.mp3"
	done < <(find . -maxdepth 1 -type f -regextype posix-extended -regex '.+\.(wav|flac)')
}

main "$@"
