#!/bin/ash

# Set debug Mode
if [[ ! -z "${DEBUG}" ]]; then
    set -ex
else
    set -e +x
fi

nc -zv 127.0.0.1 5700 >/dev/null 2>&1 || exit 1
nc -zv 127.0.0.1 8000 >/dev/null 2>&1 || exit 1

exit 0
