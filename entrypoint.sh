#!/bin/bash

set -e

curl -o run_infersharp.sh https://raw.githubusercontent.com/microsoft/infersharpaction/xinshi/failonwarning/run_infersharp_ci.sh
chmod +x run_infersharp.sh
./run_infersharp.sh "$1" "$2"

results="$( cat infer-out/report.txt )"
results="${results//'"'/''}"
results="${results//'%'/'%25'}"
results="${results//$'\n'/'%0A'}"
results="${results//$'\r'/'%0D'}"
echo "::set-output name=results::$results"
