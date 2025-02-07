#!/usr/bin/env zsh

function linesInFile() {
    local lineCount=0
    if [[ $# -eq 0 ]]; then
        echo "0"
        return 1
    fi

    if [[ $# -eq 1 && $1 == "--help" ]]; then
        __linesInFile_help
        return
    fi

    if [[ ! -f  $1 ]]; then
        echo "0"
        return 2
    fi

    while read -r line
    do
        lineCount=$((lineCount+1))
    done < "$1"
    echo "$lineCount"
}

function __linesInFile_help() {
    echo "Usage:"
    echo "linesInFile filename"
    echo "    filename can be relative or absolute"
}

function linesInFile_oneliner() {
    echo ""
}