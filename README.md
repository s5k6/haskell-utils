
**Note: This is experimental.**


Hoogle
======

Install `hoogle`.  It is available as Arch Linux package.

    $ hoogle generate

    $ hoogle server
    $ firefox 'http://localhost:8080'


Stack configuration
===================

    $ mkdir ~/.stack
    $ cp -t ~/.stack/config.yaml stack_config.yaml

Note: Exclude the subdirectories from backup.  It will exceed mutliple
gigabytes!

    $ t=~/.nobackup/_stack/
    $ mkdir "$t"
    $ for i in */ *.sqlite3*; do
          mv "$i" "$t"
          ln -s "$t/$i"
      done


Stack templates for Haskell projects
====================================

See [the `stack templates` command][1] for tenuous documentation.

Templates are defined below `./src`, and need to be combined into a
template files by running:

    $ ./mkStackTemplates

Each directory `./src/foo` yields a template `.hsfiles/foo.hsfiles`,
with `foo` substituted consistently.

The files in `./src/foo` will show up in the template, with the
following modifications applied:

  * A leading `_` is removed from each path component.  This can be
    used to make hidden files visible, and hide them from other tools.
    E.g., add file `_.gitignore` to the source directory to get
    `.gitignore` in the template.

To use one of the templates, put something like the following into
your `~/.stack/config.yaml`:

    templates:
      params:
        author-name: xxx
        author-email: yyy

        resolver: zzz

    default-template: /path/to/repo/.hsfiles/stub.hsfiles

Pay particular attention to the “resolver” to be used by `stack`.
This is the one to be used initially for all newly created projects.
Choose a recent one from the [current list of snapshots][2].

Now `stack` can create a new project `lala`:

    $ stack new lala


Shell convenience
=================

The `./bash` directory provides additional shell convenience.
Sourcing `hs.bash` makes available the `hs` shell function,
dispatching to the various scripts provided in that directory.

To do this on demand, either source manually, or add a construction
like

    function hs {
        unset hs
        if source /path/to/haskell-utils/bash/hs.bash; then
            hs "$@"
        fi
    }

to your `~/.bashrc`, adjusting the `/path/to/haskell-utils/` as
appropriate.


New project
-----------

    $ hs new /path/to/project

creates a *new* project using the default template, initialises a git
repository, compiles the program, sets the current working directory
there, and replaces the shell with `stack exec $SHELL` so that the
compiled program is on the PATH.

    $ hs new /tmp/foo/bar/qux
    …
    $ qux
    This is qux.                # output of program from template

**Note**, that the `.stack-work` directory is initally created as a
symlink to temporary storage.  You may want to change this.


Compilation
-----------

    $ hs build …
    $ hs loop …

These are frontends to `stack build`, the latter running with
`--file-watch`, both passing on additional arguments.

In any case, if `.stack-work` does not exist, it is created in a
temporary location (determined by `mktemp`) and symlinked to the
current directory.  A stale symlink is removed first.  An existing
directory is left intact.

The idea is to not clutter your disk (and backups) with the bulky
remains of compilation, but to leave you a choice:  Use

    $ hs keep

To convert a symlink `.stack-work` into a real directory, *moving* its
contents.  If absent, an empty directory is created.



Existing projects
-----------------

To just replace the shell with `stack exec $SHELL` of an existing
project, run

    $ hs sh [-f]

in the project directory.  This will refuse to work if
`GHC_ENVIRONMENT` is already present in the environment, unless `-f`
is given.

Note, that `hs sh` also performs some cleanup on the environment to
help avoid accumulating invalid data from previous calls, (`stack`
only seems to prepend to `PATH`, allowing to have paths from diffent
projects there.  I currently do not see a reason to want that).

If you want to bring the binary of a project into scope without
changing your current working directory, use

    $ hs sh [-f] PATH

Which runs `stack exec` *after* changing to PATH, but then runs a
shell in your current working directory.



Docs
----

    $ hs doc       # build documentation…
    $ hd doc pkg   # …and go to index for local packages
    $ hs doc dep   # …and go to index for local packages and dependencies
    $ hs doc snap  # …and go to index for snapshot packages



[1]: https://docs.haskellstack.org/en/stable/templates_command/
[2]: https://www.stackage.org/snapshots
