#!/bin/bash

curl -o run_infersharp.sh https://raw.githubusercontent.com/microsoft/infersharp/v1.2/run_infersharp_ci.sh
chmod +x run_infersharp.sh
./run_infersharp.sh "$1"

printf '\n\nAnalysis Result\n'
printf '%50s\n' | tr ' ' =
cat infer-out/report.txt