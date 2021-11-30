#!/bin/bash

curl -o run_infersharp.sh https://raw.githubusercontent.com/microsoft/infersharpaction/v1.2.1/run_infersharp_ci.sh
chmod +x run_infersharp.sh
./run_infersharp.sh "$1"

results="$( cat infer-out/report.txt )"
results="${results//'"'/''}"
results="${results//'%'/'%25'}"
results="${results//$'\n'/'%0A'}"
results="${results//$'\r'/'%0D'}"
echo "::set-output name=results::$results"
