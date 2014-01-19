Chnode.sh
=========
[![NPM version][npm-badge]](http://badge.fury.io/js/chnode)
[npm-badge]: https://badge.fury.io/js/chnode.png

Change between installed Node version in your current shell with a simple
`chnode VERSION`. Leaves the system version untouched. Works out of the box with
Mac's [Homebrew][homebrew].

[homebrew]: https://github.com/Homebrew/homebrew

### Tour
- Change only the current shell without affecting the rest of the system.
- Works out of the box with paths used by Mac's [Homebrew][homebrew].
- Extendable by adding more Node paths to the `NODES` variable.
- Leaves installing Node versions to your package manager thereby adhering to
  the *do one thing and do it well* principle.
- Works in Bash and Zsh. And possibly other POSIX compatible shells.
- Does not pollute your shell namespaces with internal functions.
- Lightweight.
- Written in the shell language. [KISS][kiss].

Side note: I'm terribly ashamed of not yet having tests!

[kiss]: https://en.wikipedia.org/wiki/Keep_it_simple_stupid


Installing
----------
Install Chnode.sh globally with:
```sh
npm install --global chnode
```

Then source it in your shell:
```sh
. "$(npm bin --global)/chnode"
```

For convenience you might want to put the **output** of the following in your
`.zshrc` or `.bashrc`.  
It'll be faster than running the line above with `npm bin` which will slow down
your shell loading.
```sh
echo ". \"$(npm bin --global)/chnode\""
```


Using
-----
Change between installed Node versions with:
```sh
chnode 0.11.7
```

### Options
Option           | Description
-----------------|------------
`-h, -?, --help `| Display this help.
`-r, --refresh  `| Refresh and find all available Node versions.
`-l, --list     `| List all available Node versions.


Configuring
-----------
On the Mac Chnode.sh will find installed Nodes in `/usr/local/Cellar/node`.  
If you've got installations somewhere else, set the `NODES` variable to an
**array of paths** of **individual versions**:
```sh
NODES+=(~/.nodes/*)
```

For example, if you've got Node compiled from the source at
`~/Development/node-master`, append that:
```sh
NODES+=(~/Development/node-master)
```

If you think Chnode.sh should detect some of your paths automatically, please
let me know by [creating an issue][issues]. Thanks!


License
-------
Chnode.sh is released under a *Lesser GNU Affero General Public License*, which
in summary means:

- You **can** use this program for **no cost**.
- You **can** use this program for **both personal and commercial reasons**.
- You **do not have to share your own program's code** which uses this program.
- You **have to share modifications** (e.g bug-fixes) you've made to this
  program.

For more convoluted language, see the `LICENSE` file.


About
-----
**[Andri Möll](http://themoll.com)** typed this and the code.  
[Monday Calendar](https://mondayapp.com) supported the engineering work.

If you find Chnode.sh needs improving, please don't hesitate to type to me now
at [andri@dot.ee][email] or [create an issue online][issues].

[email]: mailto:andri@dot.ee
[issues]: https://github.com/moll/sh-chnode/issues
