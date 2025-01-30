# -*- shell-script -*-

HASKELL_UTILS_PATH="${BASH_SOURCE%/*}"

function hs {

    cmd="${1:-help}"
    shift

    case "${cmd}" in

        build)
            "${HASKELL_UTILS_PATH}/hs-build" "$@"
            ;;

        clean)
            "${HASKELL_UTILS_PATH}/hs-clean"
            ;;

        doc)
            "${HASKELL_UTILS_PATH}/hs-doc" "$@"
            ;;

        keep)
            "${HASKELL_UTILS_PATH}/hs-keep" "$@"
            ;;

        loop)
            "${HASKELL_UTILS_PATH}/hs-build" --file-watch "$@"
            ;;

        new)
            if "${HASKELL_UTILS_PATH}/hs-new-project" "${@}"; then
                cd "${@}"
                exec "${HASKELL_UTILS_PATH}/hs-shell"
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

            exec "${HASKELL_UTILS_PATH}/hs-shell" "$@"
            ;;

        tags)
            "${HASKELL_UTILS_PATH}/hs-tags" "$@"
            ;;

        *)
            echo 'Subcommands: build, clean, doc, keep, loop, new, sh, tags'
            return 1
            ;;

    esac

}
