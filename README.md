
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

Each directory `./src/foo` yields a template `hsfiles/foo.hsfiles`,
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

    default-template: /path/to/repo/hsfiles/stub.hsfiles

Pay particular attention to the “resolver” to be used by `stack`.
This is the one to be used initially for all newly created projects.
Choose a recent one from the [current list of snapshots][2].

Now `stack` can create a new project `lala`:

    $ stack new lala


Shell convenience
=================

The `./tools` directory provides additional shell convenience.  The
executable files must be put on your PATH, and `haskell.bash` must be
sourced from your bash.

The latter adds a function `hs` to your shell.  If you only want to do
this on demand, you may either source manually, or add a construction
like

    function hs {
        unset hs
        if source /path/to/haskell-utils/bash/hs.bash; then
            hs "$@"
        fi
    }

to your `~/.bashrc`, which only loads `hs.bashrc` on first use of the
`hs` function.  Of course, modify the path as required.


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


Existing projects
-----------------

To just replace the shell with `stack exec $SHELL` of an existing
project, run

    $ hs sh

in the project directory.  This will refuse to work if
`GHC_ENVIRONMENT` is already present in the environment, which you may
simply `unset` of course.  Note, that `hs sh` also performs some
cleanup on the environment to help avoid accumulating invalid data
from previous calls, (`stack` only seems to prepend to `PATH`,
allowing to have paths from diffent projects there.  I currently do
not see a reason to want that).

If you want to bring the binary of a project into scope without
changing your current working directory, use

    $ hs sh /path/to/project



Docs
----

    $ hs doc       # build documentation…
    $ hd doc pkg   # …and go to index for local packages
    $ hs doc dep   # …and go to index for local packages and dependencies
    $ hs doc snap  # …and go to index for snapshot packages


Developing
----------

    $ hs loop …    # this is simply $ stack build --file-watch …



[1]: https://docs.haskellstack.org/en/stable/templates_command/
[2]: https://www.stackage.org/snapshots
