#!/bin/sh
if [ -z "$PS1" -a -z "$PS2" ]; then
	echo "Please source chnode to your shell with \". $0\"."
fi

# Variable to hold all found Node version paths.
NODES=()

chnode() {
	[ -z "$NODES" ] && NODES=1 && chnode --silent-refresh

	case "$1" in
		"" | -h | -\? | --help)
			echo "Usage: chnode [OPTIONS] VERSION"
			echo
			echo "Options:"
			echo "    -h, -?, --help  Display this help."
			echo "    -r, --refresh   Refresh and find all available Node versions."
			echo "    -l, --list      List all available Node versions."
			echo
			echo "Available Node versions:"
			CHNODE_INDENT="    " chnode --list
			;;

		-r | --refresh)
			echo "Refreshing..."
			chnode --silent-refresh
			chnode --list
			;;

		--silent-refresh)
			NODES=()
			[ -d /usr/local/Cellar/node ] && NODES+=(/usr/local/Cellar/node/*)
			;;

		-l | --list)
			local dir
			for dir in "${NODES[@]}"; do echo "$CHNODE_INDENT$(basename "$dir")"; done
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
			echo "Switched to Node v$1 at $root."

			# Have shell refresh its cache of binaries.
			hash -r
			;;
	esac
}
