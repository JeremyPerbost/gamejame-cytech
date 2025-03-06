#!/bin/sh
echo -ne '\033c\033]0;game jame\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/CY2PIE_linux.x86_64" "$@"
