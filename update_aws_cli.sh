#!/bin/bash

set -eu

main () {
	local zip_name='awscliv2.zip'
	curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o $zip_name
	unzip $zip_name
	sudo ./aws/install --update
	rm -r ./aws ./$zip_name
}

main
