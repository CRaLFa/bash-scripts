#!/bin/bash

main () {
	local zip_name='awscliv2.zip'
	curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o "$zip_name" || return
	unzip "$zip_name" || return
	sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update || return
	rm -r ./aws "./${zip_name}"
}

main
