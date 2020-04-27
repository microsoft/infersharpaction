#!/bin/bash

echo "Running C# Code Analyzer..."
sudo mkdir codeanalyzerinputbinaries
sudo cp -r $1 /app/Cilsil/bin/Debug/netcoreapp2.2/ubuntu.16.10-x64/publish/System.Private.CoreLib.dll codeanalyzerinputbinaries   
sudo infer capture
sudo mkdir infer-out/captured
sudo dotnet /app/Cilsil/bin/Debug/netcoreapp2.2/Cilsil.dll translate codeanalyzerinputbinaries --outcfg cfg.json --outtenv tenv.json
sudo infer analyzejson --debug --cfg-json cfg.json --tenv-json tenv.json
sudo chmod -R 777 infer-out/
sudo dotnet /app/TelemetrySender/TelemetrySender/bin/Debug/netcoreapp2.2/TelemetrySender.dll GitHub $2 $3 infer-out/bugs.txt

var="$( cat -s infer-out/bugs.txt | sed -E -e '/ANALYSIS_STOP|Bad_footprint|Missing_fld|PRECONDITION_NOT_MET|CONDITION_ALWAYS_FALSE|NULL_TEST_AFTER_DEREFERENCE|Assert_failure|CLASS_CAST_EXCEPTION|Abduction_case_not_implemented|Found.[0-9]+.issues|Summary.of.the.report/,/^[[:space:]]*$/d' )"
echo "$var"
var="${var//'%'/'%25'}"
var="${var//$'\n'/'%0A'}"
var="${var//$'\r'/'%0D'}"
echo "$var"
echo "::set-output name=results::$var"