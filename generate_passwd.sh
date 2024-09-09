#!/bin/bash

main () {
    local lower='false' upper='false'

    while getopts 'hlu' OPT
    do
        case $OPT in
            'h')
                echo "Usage: $(basename "$0") [-hlu] [LENGTH]"
                return 0
            ;;
            'l')
                lower='true'
            ;;
            'u')
                upper='true'
            ;;
            *)
                return 1
            ;;
        esac
    done

    shift $(( OPTIND - 1 ))

    local rand_str=$(base64 /dev/random | head | paste -sd '')
    local -i len=${1:-10}
    local pw=${rand_str:0:$len}

    eval $lower && pw=${pw,,}
    eval $upper && pw=${pw^^}

    echo $pw
}

main "$@"
