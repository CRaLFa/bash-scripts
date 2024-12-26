#!/bin/bash

set -eu

main () {
	local zip_name='aws-sam-cli.zip' ex_dir='sam-installation'
	curl -L 'https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip' -o $zip_name
	unzip $zip_name -d $ex_dir
	sudo ./$ex_dir/install --update
	rm -r ./$ex_dir ./$zip_name
}

main
