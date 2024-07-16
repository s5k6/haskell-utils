
Note: This is experimental.

See [1].

To generate the templates from their sources (below `src`), run:

    $ ./generate

To use one of them, put the following into your `~/.stack/config.yaml`:

    templates:
      params:
        author-name: xxx
        homepage: yyy
        author-email: zzz

    default-template: /path/to/repo/hsfiles/stub.hsfiles


[1]: https://docs.haskellstack.org/en/stable/templates_command/
