#!/bin/sh
if [ -z "$PS1" -a -z "$PS2" ]; then
	echo "Please load chnode to your shell with: . $0" >&2
	exit 1
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
			local current="$(node --version 2>/dev/null)"; current=${current#v}
			local version
			for version in $(chnode --list); do
				local marker=
				[ -n "$current" -a "$current" = "$version" ] && marker=" *"
				echo "    $version$marker"
			done
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
			for dir in "${NODES[@]}"; do echo "$(basename "$dir")"; done
			;;

		*)
			# Support both v0.11.5 and 0.11.5 syntax.
			local version="${1#v}"

			# Clean up PATH from old Node versions and ugly stray colons.
			local dir
			PATH=":$PATH:"
			for dir in "${NODES[@]}"; do PATH=${PATH/:${dir}\/bin:/:}; done
			PATH=${PATH#:}; PATH=${PATH%:}

			local root
			for dir in "${NODES[@]}"; do
				[ "$(basename "$dir")" = "$version" ] && root=$dir && break
			done

			[ -z "$root" ] && echo "Sorry, couldn't locate Node $version." && return
			PATH=$root/bin:$PATH
			# No news is good news:
			#echo "Switched to Node $version at $root."

			# Have shell refresh its cache of binaries.
			hash -r
			;;
	esac
}
