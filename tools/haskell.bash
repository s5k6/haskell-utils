# -*- shell-script -*-

function hs {

    cmd="${1:-help}"
    shift

    case "${cmd}" in

        build)
            haskell-build "$@"
            ;;

        clean)
            haskell-clean
            ;;

        doc)
            haskell-doc "$@"
            ;;

        loop)
            haskell-build --file-watch "$@"
            ;;

        new)
            if haskell-new-project "${@}"; then
                cd "${@}"
                exec haskell-shell
            fi
            ;;

        sh)
            if test "${1-}" = -f; then
                shift 1
            elif test -v GHC_ENVIRONMENT; then
                echo 'Found in environment: GHC_ENVIRONMENT'
                return 1
            fi

            d="${1:-.}"

            if ! test -f "${d}/stack.yaml"; then
                echo "Not found file: ${d}/stack.yaml"
                return 1
            fi

            exec haskell-shell "$@"
            ;;

        tags)
            haskell-tags "$@"
            ;;

        *)
            echo 'Subcommands: build, doc, loop, new, sh, tags'
            return 1
            ;;

    esac

}
