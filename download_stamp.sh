#!/bin/bash

main () {
    (( $# < 1 )) && {
        echo "Usage: $(basename $0) PRODUCT_ID" >&2
        return 1
    }

    local product_url img_html os stamp_url

    product_url="https://store.line.me/stickershop/product/$1/ja"
    img_html=$(curl -s "$product_url" | grep '"mdCMN09Image"') || {
        echo 'Not found' >&2
        return 1
    }
    os=$(echo "$img_html" | head -n 1 | grep -Po '\d{5}/\K\w+')

    case "$os" in
        'android')
            png='sticker.png' ;;
        'iPhone')
            png='sticker@2x.png' ;;
        *)
            return 1 ;;
    esac

    while read -r id
    do
        stamp_url="https://stickershop.line-scdn.net/stickershop/v1/sticker/${id}/${os}/${png}"
        echo "$stamp_url"
        curl -sS "$stamp_url" -o "${id}.png"
    done < <(echo "$img_html" | grep -Po '\d{5,}')
}

main "$@"
