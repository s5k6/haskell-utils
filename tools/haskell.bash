# -*- shell-script -*-

function hs {

    cmd="${1:-help}"
    shift

    case "${cmd}" in

        sh)
            if test -v GHC_ENVIRONMENT; then
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

        new)
            if haskell-new-project "${@}"; then
                cd "${@}"
                exec haskell-shell
            fi
            ;;

        loop)
            stack build --file-watch "$@"
            ;;

        doc)
            haskell-doc "$@"
            ;;

        *)
            echo 'Subcommands: sh, new, loop, doc'
            return 1
            ;;

    esac

}
