#! /bin/bash
#
# \\\ wami ///
# /// 12-Feb-2015 \\\
#
#
# Build script
#

function usage() {
    echo "Usage:" `basename $0` "[debug | release] [local | server]"
    exit 1
}

if [[ $# -ne 2 ]]; then
    usage
fi

if [[ ! -f "./index.js" ]]; then
    echo "Please, run this script from scrollback-ii main directory"
    exit 1
fi

# Environment setup
case "$1" in
    debug)
        echo "Setting up debug environment..."
        sed -i -e 's/env: "production"/env: "dev"/g' ./server-config.js
        sed -i -e 's/env: "production"/env: "dev"/g' ./ircClient/config.js
        ;;
    release)
        echo "Setting up release environment..."
        sed -i -e 's/env: "dev"/env: "production"/g' ./server-config.js
        sed -i -e 's/env: "dev"/env: "production"/g' ./ircClient/config.js
        ;;
    *)
        usage
        ;;
esac
case "$2" in
    local)
        echo "Setting up local environment..."
        sed -i -e 's/host: "\/\/informateci.org:8181"/host: "\/\/local.scrollback.io:8181"/g' ./client-config.js
        sed -i -e 's/    "vanilla"];/];\/\/!vanilla/g' ./index.js
        ;;
    server)
        echo "Setting up informateci environment..."
        sed -i -e 's/host: "\/\/local.scrollback.io:8181"/host: "\/\/informateci.org:8181"/g' ./client-config.js
        sed -i -e 's/];\/\/!vanilla/    "vanilla"];/g' ./index.js
        ;;
    *)
        usage
        ;;
esac

# Build
echo "Starting gulp..."
gulp
