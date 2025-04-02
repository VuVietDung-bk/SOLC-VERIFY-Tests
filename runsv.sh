#!/bin/bash

set -Eeuxo pipefail

ABSPATH=`realpath $1`
DIR=`dirname $ABSPATH`
FILE=/host/`basename $ABSPATH`
shift

docker run -it --rm --mount type=bind,source="$DIR",target=/host solc-verify:latest $FILE $@