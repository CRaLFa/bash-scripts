#!/bin/bash

if (( $# < 1 )); then
    echo 'Usage: dlstamp PRODUCT_ID' >&2
    exit 1
fi

product_url="https://store.line.me/stickershop/product/$1/ja"
img_html=$(curl -sS "$product_url" | grep '"mdCMN09Image"') || {
    echo 'Not found' >&2
    exit 1
}
os=$(echo "$img_html" | head -n 1 | grep -Po '(?<=\d{5}\/)\w+')

case "$os" in
    'android')
        png='sticker.png' ;;
    'iPhone')
        png='sticker@2x.png' ;;
    *)
        exit 1 ;;
esac

while read -r id
do
    stamp_url="https://stickershop.line-scdn.net/stickershop/v1/sticker/${id}/${os}/${png}"
    echo "$stamp_url"
    curl -sS "$stamp_url" -o "${id}.png"
done < <(echo "$img_html" | grep -Po '\d{5,}')
