#!/bin/bash

echo "Running Infer#..."
sudo mkdir codeanalyzerinputbinaries
sudo cp -r $1 /app/Cilsil/System.Private.CoreLib.dll codeanalyzerinputbinaries   
sudo infer capture
sudo mkdir infer-out/captured
sudo dotnet /app/Cilsil/Cilsil.dll translate codeanalyzerinputbinaries --outcfg cfg.json --outtenv tenv.json
sudo infer analyzejson --debug --cfg-json cfg.json --tenv-json tenv.json
sudo chmod -R 777 infer-out/
reportonfiles=$(echo $2 | sed 's/ /,/g')
sudo dotnet /app/AnalysisResultParser/AnalysisResultParser.dll infer-out/bugs.txt infer-out/filtered_bugs.txt $reportonfiles

var="$( cat infer-out/filtered_bugs.txt )"
var="${var//'%'/'%25'}"
var="${var//$'\n'/'%0A'}"
var="${var//$'\r'/'%0D'}"
echo "::set-output name=results::$var"