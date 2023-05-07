#!/bin/bash
function check_version() {
    path=$1
    target=$2

    echo "🔍 Checking Chart Version for $path against $target"

    new=$(git diff "$target" -- "$path" | sed -nr 's/^\+version: (.*)$/\1/p')
    old=$(git diff "$target" -- "$path" | sed -nr 's/^\-version: (.*)$/\1/p')

    if [[ -z "$new" ]]; then
        echo "❌ Chart version not changed, exiting..."
        exit 1
    fi

    echo "🔙 Old Chart Version: $old"
    echo "🆕 New Chart Version: $new"

    if [[ $(echo "$new\n$old" | sort -V -r | head -n1) != "$old" ]]; then
        echo "✅ Chart version bumped, continuing..."
    else
        echo "❌ Chart version not bumped or downgraded, exiting..."
    fi
}
# TODO: Replace master with PR target branch or something, also move to a script
check_version "$1" ${2:-"origin/master"}
