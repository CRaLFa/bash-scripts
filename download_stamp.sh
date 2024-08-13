#!/bin/bash

main () {
    (( $# < 1 )) && {
        echo "Usage: $(basename $0) PRODUCT_ID" >&2
        return 1
    }

    local line img_url id

    while read -r line
    do
        img_url=$(grep -Po '(?<=url\()[^)]+' <<< "$line")
        echo "$img_url"
        id=$(grep -Po 'sticker/\K\d+' <<< "$img_url")
        curl -sS "$img_url" -o "${id}.png"
    done < <(curl -s "https://store.line.me/stickershop/product/$1/ja" | grep '"mdCMN09Image"')
}

main "$@"
