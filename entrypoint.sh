#!/usr/bin/env bash
set -eo pipefail

if [ $# -eq 0 ]; then
    exec nagini --help
fi

if [ "$1" = "nagini" ]; then
    shift
    [ $# -eq 0 ] && exec nagini --help
fi

if [ "${1:0:1}" = "-" ] || [[ "$1" == *.py ]]; then
    exec nagini "$@"
fi

if command -v "$1" >/dev/null 2>&1 && [ "$1" != "nagini" ] && [ ! -f "$1" ]; then
    exec "$@"
fi

exec nagini "$@"
