#!/bin/bash

# Usage
# $ get_latest_release "creationix/nvm"
# v0.31.4
#
# See: https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		grep '"tag_name":'					| # Get tag line
		sed -E 's/.*"([^"]+)".*/\1/'				  # Pluck JSON value
}

# See: https://devcenter.heroku.com/articles/buildpack-api#bin-compile-summary
export_env_dir() {
	env_dir=$1
	whitelist_regex=${2:-''}
	blacklist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'}
	if [ -d "$env_dir" ]; then
		if [ -f $env_dir/PORT ] ; then
			PORT="$(cat $env_dir/PORT)"
		fi
		for e in $(ls $env_dir); do
			PORT="$(cat $env_dir/PORT)"
			echo "$e" | grep -E "$whitelist_regex" | grep -qvE "$blacklist_regex" &&
				port_escaped=$(echo "$e=$(cat $env_dir/$e)") &&			 # 0.0.0.0:\$PORT
				port_unescaped=$(sed 's/\\\$/$/g' <<< $port_escaped)		 # 0.0.0.0:$PORT
				port_expanded=$(eval "printf $port_unescaped") &&		 # 0.0.0.0:12345
				export $port_expanded
			:
		done
	fi
}
