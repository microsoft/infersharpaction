#!/bin/bash

curl -o run_infersharp.sh https://raw.githubusercontent.com/microsoft/infersharp/v1.2/run_infersharp_ci.sh
chmod +x run_infersharp.sh
./run_infersharp.sh "$1"

echo "::set-output name=output_txt::$(cat infer-out/report.txt)"
echo "::set-output name=output_sarif::$(cat infer-out/report.sarif)"