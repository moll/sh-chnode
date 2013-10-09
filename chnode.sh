#!/bin/sh
if [ -z "$PS1" -a -z "$PS2" ]; then
	echo "Please source chnode to your shell with \". $0\"."
fi

NODES=()
[ -d /usr/local/Cellar/node ] && NODES+=(/usr/local/Cellar/node/*)

chnode() {
	case "$1" in
		"" | -h | -\? | --help)
			echo "Usage: chnode [OPTIONS] VERSION"
			echo
			echo "Options:"
			echo "    -h, -?, --help  Display this help."
			echo
			echo "Available Node versions:"

			local dir
			for dir in "${NODES[@]}"; do echo "    $(basename "$dir")"; done
			;;

		*)
			# Support both v0.11.5 and 0.11.5 syntax.
			local version="${1#v}"

			# Clean up PATH from old Node versions and ugly stray colons.
			local dir
			for dir in "${NODES[@]}"; do PATH=${PATH/${dir}/}; done
			PATH=${PATH/::/}; PATH=${PATH#:}; PATH=${PATH%:}

			local root
			for dir in "${NODES[@]}"; do
				[ "$(basename "$dir")" = "$version" ] && root=$dir && break
			done

			[ -z "$root" ] && echo "Sorry, couldn't locate Node v$version." && return
			PATH=$root:$PATH

			# Have shell refresh its cache of binaries.
			hash -r
			;;
	esac
}
