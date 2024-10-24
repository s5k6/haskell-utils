# -*- shell-script -*-

HASKELL_UTILS_PATH="${BASH_SOURCE%/*}"

function hs {

    cmd="${1:-help}"
    shift

    case "${cmd}" in

        build)
            "${HASKELL_UTILS_PATH}/haskell-build" "$@"
            ;;

        clean)
            "${HASKELL_UTILS_PATH}/haskell-clean"
            ;;

        doc)
            "${HASKELL_UTILS_PATH}/haskell-doc" "$@"
            ;;

        loop)
            "${HASKELL_UTILS_PATH}/haskell-build" --file-watch "$@"
            ;;

        new)
            if "${HASKELL_UTILS_PATH}/haskell-new-project" "${@}"; then
                cd "${@}"
                exec "${HASKELL_UTILS_PATH}/haskell-shell"
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

            exec "${HASKELL_UTILS_PATH}/haskell-shell" "$@"
            ;;

        tags)
            "${HASKELL_UTILS_PATH}/haskell-tags" "$@"
            ;;

        *)
            echo 'Subcommands: build, clean, doc, loop, new, sh, tags'
            return 1
            ;;

    esac

}
