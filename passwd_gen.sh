#!/bin/bash

len=10
(( $# > 0 )) && len=$1
base_str=$(cat /dev/urandom | base64 | head | paste -sd '')
echo ${base_str:0:$len}
