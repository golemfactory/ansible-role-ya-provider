#!/bin/bash

# usage: cleanup_releases.sh used_subnets...
# It's OK to provide a subnet name, which doesn't exists on host

shopt -s nullglob

declare -A used_releases
for subnet in "$@"; do
    if [[ ! -d "$subnet" ]]; then
        continue
    fi
    for rel in $(realpath "${subnet}"/plugins/* | grep -E -o "${HOME}/releases/[^/]+/"); do
        used_releases[$rel]=1
    done
done

for rel in ~/releases/{golem-provider,ya-runtime}-*/; do
    if [[ "${used_releases[$rel]}" != "1" ]]; then
        echo "removing $rel"
        rm -r "$rel"
    fi
done
