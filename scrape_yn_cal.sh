#!/bin/bash

set -ue

readonly CALENDAR_URL='http://yurinavi.com/yuri-calendar/'
readonly MANGAPEDIA_URL='https://mangapedia.com'

list_cal_urls () {
	cat <(echo "$CALENDAR_URL") <(curl -s "$CALENDAR_URL" | pup '#tablepress-152-no-2 a attr{href}')
}

list_comics () {
	while read -r url
	do
		curl -s "$url" \
			| pup 'article thead + tbody td.column-3:parent-of(br) text{}' \
			| nkf -Z \
			| grep -Pv '^([ 　]|$| *※|【.+版】|ガレット|パルフェ |サクラクエスト外伝|Lガールズ\(5\))' \
			| grep -Pv '(月号|雑誌|特集)' \
			| perl -pe 's/&amp;/&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g;' \
			| perl -pe 's/ +$//g; s/ *\[[^]]+\]//g; s/【.+版】//g; s/ *[Vv]ol.+$//g; s/ *\(([\d.上中下]+|.*著|.+版)\).*$//g; s/ *[\d.]+( *.+版)?$//g; s/((原)*作(者)*|漫画)://g'
	done < <(list_cal_urls)
}

search_kana () {
	local name="$1"
	[[ "$name" =~ [一-龠々] ]] || return 0

	local page_url=$(curl -sGL --data-urlencode "search_term_string=${name}" "${MANGAPEDIA_URL}/search" \
		| pup '#SCT2 div.box a attr{href}')
	[ -z "$page_url" ] && return 0

	echo -n $(curl -s "${MANGAPEDIA_URL}${page_url}" | pup 'dd[itemprop="ruby"] text{}')
}

output () {
	local title="$1" author="$2"

	[[ "$author" == *アンソロジー* ]] && return 0

	_IFS="$IFS"
	IFS=','
	local names=( $(perl -pe 's/ *\/ */,/g' <<< "$author") ) kanas=()

	for name in "${names[@]}"
	do
		kanas+=( $(search_kana "$name") )
	done

	echo -e "${title}\t${names[*]}\t${kanas[*]}"
	IFS="$_IFS"
}

main () {
	echo -e "作品名\t作者\t作者(読み)"

	export MANGAPEDIA_URL
	export -f search_kana output
	list_comics | parallel -L 2 -k 'output {1} {2}' 2> /dev/null
}

main
