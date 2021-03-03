#!/bin/bash

echo "Running Infer#..."
sudo mkdir codeanalyzerinputbinaries
sudo cp -r $1 /app/Cilsil/System.Private.CoreLib.dll codeanalyzerinputbinaries
sudo dotnet /app/Cilsil/Cilsil.dll translate codeanalyzerinputbinaries --outcfg cfg.json --outtenv tenv.json
echo -e "\e[1;33mYou may see 'Unable to parse instruction xxx' above. This is expected as we have not yet translated all the CIL instructions, which follow a long tail distribution. We are continuing to expand our .NET translation coverage. \e[0m\n"
echo -e "Translation completed. Analyzing...\n"
sudo infer capture
sudo mkdir infer-out/captured
sudo infer $(infer help --list-issue-types 2> /dev/null | grep ':true:' | cut -d ':' -f 1 | sed -e 's/^/--disable-issue-type /') --enable-issue-type NULL_DEREFERENCE --enable-issue-type DOTNET_RESOURCE_LEAK analyzejson --debug --cfg-json $1/cfg.json --tenv-json $1/tenv.json

var="$( cat infer-out/report.txt )"
var="${var//'%'/'%25'}"
var="${var//$'\n'/'%0A'}"
var="${var//$'\r'/'%0D'}"
echo "::set-output name=results::$var"