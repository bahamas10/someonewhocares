#!/usr/bin/env bash
#
# Pull and install the latest host file
# from someonewhocares.org (Dan Pollock)
#
# Author: Dave Eddy <dae@daveeddy.com>
# Date: 11/24/13
# License: MIT

usage() {
	local prog=${0##*/}
	cat <<-EOF
	usage: $prog [options]

	pull and install the latest host file from someonewhocares.org

	options
	  -h           print this message and exit
	  -t <type>    the host file type to pull, can be [ipv6, zero], leave blank for default
	  -u           uninstall the host file by replacing it with a default template
	EOF
}

# replace the host file with a basic default template
uninstall() {
	local default=$(cat <<-EOF
	# replaced by ${0##*/} on $(date)
	127.0.0.1	localhost
	255.255.255.255	broadcasthost
	::1             localhost
	fe80::1%lo0	localhost
	EOF)
	echo '> replacing host file'
	if ! _install <<< "$default"; then
		echo '> failed!'
		return 1
	fi
	echo '> done'
}

# install a host file into place taken over stdin
_install() {
	local hosts=$(cat)
	if ! tee /etc/hosts <<< "$hosts" > /dev/null; then
		echo '> failed - retrying with sudo' >&2
		sudo tee /etc/hosts <<< "$hosts" > /dev/null
	fi
}

_type=
while getopts 'ht:u' option; do
	case "$option" in
		h) usage; exit 0;;
		t) _type=$OPTARG;;
		u) uninstall; exit $?;;
		*) usage >&2; exit 1;;
	esac
done
shift "$((OPTIND - 1))"

url=http://someonewhocares.org/hosts/$_type/hosts

echo -n "> pulling latest host file from $url... "
if ! hosts=$(curl -LsS "$url"); then
	echo 'failed!'
	exit 1
fi
echo 'done'

echo '> installing new host file'
if ! _install <<< "$hosts"; then
	echo '> failed!' >&2
	exit 2
fi

echo "> finished! $(grep 'Last updated: ' <<< "$hosts")"