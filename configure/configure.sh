#!/usr/bin/env bash
set -eo pipefail

function clrd() {
    # 31 = red
    # 32 = green
    # 33 = yellow
    # 35 = magenta
    # 36 = cyan
    echo -e "\033[${3:-0};$2m$1\033[0m"
}

function clrn() {
    echo -n -e "\033[${3:-0};$2m$1\033[0m"
}

function run() {
    echo -n "Running " ; clrd "$1" 32 ; 
    exec "$@"
}

function append() {
    local readonly file="$1"
    local readonly indent="$2"
    local readonly group="$3"

    echo "$(printf %$((${indent}*2))s)${group}" >> "${file}"
}

function append_value() {
    local readonly file="$1"
    local readonly indent="$2"
    local readonly key="$3"
    local readonly value="$4"

    append \
        "${file}" \
        "$((indent+1))" \
        "${key} = ${value}"
}

function create_file() {
    local readonly file="$1"
  
    echo -n "Configuring " ; clrd "${file}" 32 ; 
    mkdir -p "${file%/*}"
    if [ -f "${file}" ]; then
        rm "${file}"
    fi
}

function run_script {
    local command=""
    local file=""
    local content=""
    local indent=0
    local run=0

    while [[ $# -gt 0 ]]; do
        local key="$1"

        case "${key}" in
            --file)
                file="$2"
                create_file \
                    "${file}"
                shift
                ;;
            --group-root)
                indent=0
                group="$2"
                append \
                    "${file}" \
                    "${indent}" \
                    "${group}"
                shift
                ;;
            --group)
                indent=$((indent+1))
                group="$2"
                append \
                    "${file}" \
                    "${indent}" \
                    "${group}"
                ;;
            --val)
                key="$2"
                value="$3"
                append_value \
                    "${file}" \
                    "${indent}" \
                    "${key}" \
                    "${value}"
                shift
                ;;
            --str)
                key="$2"
                value="$3"
                append_value \
                    "${file}" \
                    "${indent}" \
                    "${key}" \
                    "\"${value}\""
                shift
                ;;
            --run)
                run=1
                shift
                break
                ;;
        esac

        shift
    done

    if [[ "${run}" -eq 1 ]]; then
        run "$@"
    fi
}

run_script "$@"
exit 0
