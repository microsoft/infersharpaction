#!/bin/bash

curl -o run_infersharp.sh https://raw.githubusercontent.com/microsoft/infersharp/v1.2/run_infersharp_ci.sh
chmod +x run_infersharp.sh
./run_infersharp.sh "$1"
cat infer-out/report.txt

var=$( cat infer-out/report.txt )
echo "::set-output name=result-txt::$var"