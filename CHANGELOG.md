## Unreleased
- `chnode` will return with a non-zero exit code when unable to locate the Node
  version requested.
- Renames `-v` to `-V` as the `--version` shorthand to make room for
  `--verbose`.
- Adds `-v` and `--verbose` for printing out the version and path switched to.  
  By default, however, no news is good news.

## 1.1.0 (Apr 22, 2015)
- Detects current version correctly should it contain a revision number
  (v0.12.2_1).
- Adds special `system` version for removing all Node paths from `$PATH`.

## 1.0.1 (Jan 18, 2014)
- Changes repository URL.

## 1.0.0 (Jan 18, 2014)
- Sh! Here's a compliment: POSIX shell is more consistent than Ruby.
