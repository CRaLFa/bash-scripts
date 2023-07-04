#!/bin/bash

main () {
    local lower=false upper=false

    while getopts 'hlu' OPT
    do
        case $OPT in
            h ) echo "Usage: $(basename $0) [-hlu] [length]"; return 0 ;;
            l ) lower=true ;;
            u ) upper=true ;;
            * ) return 1 ;;
        esac
    done

    shift $(( OPTIND - 1 ))

    local -i len=$1;
    (( len == 0 && (len = 10) ))

    local rand_str=$(base64 /dev/urandom | head | paste -sd '')
    local pw=${rand_str:0:$len}

    $lower && pw=${pw,,}
    $upper && pw=${pw^^}

    echo $pw
}

main "$@"
