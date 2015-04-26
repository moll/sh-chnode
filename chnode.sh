#!/bin/sh
if [ -z "$PS1" -a -z "$PS2" ]; then
	echo "Please load chnode to your shell with: . $0" >&2
	exit 1
fi

# Variable to hold all found Node version paths.
NODES=()

chnode() {
	local verbose=0
	[ -z "$NODES" ] && NODES=1 && chnode --silent-refresh

	local arg=
	for arg in "\0" "$@"; do
		case "$arg" in
			"\0")
				set --
				;;

			--usage)
				echo "Usage: chnode [OPTIONS] VERSION"
				echo "       chnode [OPTIONS] system"
				echo "Try \"chnode --help\" for more information."
				return
				;;

			-h | -\? | --help)
				local usage="$(chnode --usage)"

				echo "${usage%$'\n'*}"
				echo
				echo "Options:"
				echo "    -h, -?, --help  Display this help."
				echo "    -l, --list      List all available Node versions."
				echo "    -r, --refresh   Refresh and find all available Node versions."
				echo "    -v, --verbose   Be verbose when changing versions."
				echo "    -V, --version   Display version information."
				echo

				echo "Available Node versions:"
				local current="$(node --version 2>/dev/null)"; current=${current#v}
				local version=
				for version in $(chnode --list); do
					local marker=
					[ -n "$current" -a "$current" = "${version%_*}" ] && marker=" *"
					echo "    $version$marker"
				done

				echo
				echo "For help or feedback please contact Andri Möll <andri@dot.ee> or"
				echo "see https://github.com/moll/sh-chnode."
				return
				;;

			-v | --verbose)
				verbose=1
				;;

			-V | --version)
				echo "Chnode.sh v1.2.0"
				echo "Copyright (C) 2013– Andri Möll <andri@dot.ee>"
				return
				;;

			-r | --refresh)
				chnode --silent-refresh
				chnode --list
				return
				;;

			--silent-refresh)
				NODES=()
				[ -d /usr/local/Cellar/node ] && NODES+=(/usr/local/Cellar/node/*)
				return
				;;

			-l | --list)
				local dir=
				for dir in "${NODES[@]}"; do echo "$(basename "$dir")"; done
				return
				;;

			-*)
				echo "chnode: Unrecognized option: $arg" >&2
				chnode --usage >&2
				return 2
				;;

			*)
				set -- "$@" "$arg"
				;;
		esac
	done

	[ $# -eq 0 ] && chnode --help && return
	[ $# -gt 1 ] && chnode --usage >&2 && return 2

	# Support both v0.11.5 and 0.11.5 syntax.
	: 1=${1#v}

	# Clean up PATH from old Node versions and ugly stray colons.
	local dir=
	PATH=":$PATH:"
	for dir in "${NODES[@]}"; do PATH=${PATH/:${dir}\/bin:/:}; done
	PATH=${PATH#:}; PATH=${PATH%:}

	if [ "$1" = system ]; then
		local current="$(node --version 2>/dev/null)"; current=${current#v}
		[ $verbose -gt 0 ] && echo "Switched to Node $current."
		return
	fi

	local root=
	local version=

	for dir in "${NODES[@]}"; do
		version="$(basename "$dir")"
		[ "${version#v}" = "$1" ] && root=$dir && break
	done

	# Prefix match finds the *latest* suitable version, so no early break.
	[ -z "$root" ] && for dir in "${NODES[@]}"; do
		version="$(basename "$dir")"
		case "${version#v}" in
			# 0      => 0.12.2
			# 0.11   => 0.11.15
			# 0.12.2 => 0.12.2-1
			# 0.12.2 => 0.12.2_1
			"$1".*.* | \
			"$1".*   | \
			"$1"-*   | \
			"$1"_*   )
				root=$dir
				verbose=1
				;;
		esac
	done

	if [ -z "$root" ]; then
		echo "Sorry, couldn't locate Node $1."
		echo
		echo "Available Node versions:"
		local version=
		for version in $(chnode --list); do echo "    $version"; done
		return 1
	fi

	PATH=$root/bin:$PATH

	# No news is good news.
	if [ $verbose -gt 0 ]; then
		echo "Switched to Node $(basename "$root") at $root."
	fi

	# Have shell refresh its cache of binaries.
	hash -r
}
