#!/bin/bash

echo "Running C# Code Analyzer..."
sudo mkdir codeanalyzerinputbinaries
sudo cp -r $1 /app/Cilsil/bin/Debug/netcoreapp2.2/ubuntu.16.10-x64/publish/System.Private.CoreLib.dll codeanalyzerinputbinaries   
sudo infer capture
sudo mkdir infer-out/captured
sudo dotnet /app/Cilsil/bin/Debug/netcoreapp2.2/Cilsil.dll translate codeanalyzerinputbinaries --outcfg cfg.json --outtenv tenv.json
sudo infer analyzejson --debug --cfg-json cfg.json --tenv-json tenv.json
sudo chmod -R 777 infer-out/
changes=$(echo $4 | sed 's/ /,/g')
sudo dotnet /app/AnalysisResultParser/AnalysisResultParser/bin/Debug/netcoreapp2.2/AnalysisResultParser.dll infer-out/bugs.txt infer-out/filtered_bugs.txt $changes
sudo dotnet /app/TelemetrySender/TelemetrySender/bin/Debug/netcoreapp2.2/TelemetrySender.dll GitHub $2 $3 infer-out/bugs.txt

var="$( cat infer-out/filtered_bugs.txt )"
var="${var//'%'/'%25'}"
var="${var//$'\n'/'%0A'}"
var="${var//$'\r'/'%0D'}"
echo "::set-output name=results::$var"