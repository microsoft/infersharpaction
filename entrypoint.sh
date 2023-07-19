#!/bin/bash

set -e

# transform binary-path from relative to absolute
SCRIPT=$(realpath -s "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
FULLPATH=$(readlink -f "$1") 

# Downlaod infersharp config
curl -o $SCRIPTPATH/.inferconfig https://raw.githubusercontent.com/microsoft/infersharp/v1.5/.inferconfig

# Add execution auth
chmod +x $SCRIPTPATH/run_infersharp_ci.sh
chmod +x $SCRIPTPATH/.inferconfig

$SCRIPTPATH/run_infersharp_ci.sh "$FULLPATH" $2 $3
