#!/bin/bash

set -e

curl -o run_infersharp.sh https://raw.githubusercontent.com/microsoft/infersharpaction/v1.4/run_infersharp_ci.sh
curl -o .inferconfig https://raw.githubusercontent.com/microsoft/infersharp/v1.4/.inferconfig
chmod +x run_infersharp.sh
chmod +x .inferconfig
./run_infersharp.sh "$1" $2
