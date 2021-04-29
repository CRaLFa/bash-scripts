#/bin/bash

if (( $# < 1 )); then
    echo 'Usage: aiqtag MUSIC_FILE' >&2
    exit 1
fi

file="$1"
mp3="${file%.*}.mp3"

if [[ "${file##*.}" != 'mp3' ]]; then
    ffmpeg -i "$file" -ac 2 -ar 44100 -b:a 320k -acodec libmp3lame -f mp3 "${mp3}" || exit $?
    sleep 1
fi

awk -F '\t' -f - << _EOT_ <(powershell.exe Get-Clipboard | tr -d '\r\n') | bash || exit $?
BEGIN {
    len = split("TIE_UP BY_TYPE title artist album_artist date genre CRITERION comment LEVEL COPYRIGHT PROGRAMLATER", tags, " ")
}
{
    printf "ffmpeg -i '%s'", "${mp3}"
    for (i = 1; i <= len; i++)
        printf " -metadata %s='%s'", tags[i], \$(i)
    printf " -codec copy -y '%s.mp3'\n", \$3
}
_EOT_

sleep 1
[ -f "${mp3}" ] && rm "${mp3}"
