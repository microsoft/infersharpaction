#!/bin/bash

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

set -e

github_sarif=$2

# Check if we have enough arguments.
if [ "$#" -lt 2 ]; then
    echo "run_infersharp.sh <dll_folder_path> <options - see https://fbinfer.com/docs/man-infer-run#OPTIONS>"
	exit 1
fi

infer_args=""

if [ "$#" -gt 2 ]; then
    i=3
    while [ $i -le $# ]
    do 		
        if [ ${!i} == "--output-folder" ]; then
            ((i++))
            output_folder=${!i}        
		else
			infer_args+="${!i} "
		fi
        ((i++))
    done
fi

if [ "$output_folder" == "" ]; then
    output_folder="$PWD/infer-out"
fi

echo -e "Output folder $output_folder"

echo "Processing {$1}"
# Preparation
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
if [ -d infer-staging ]; then rm -Rf infer-staging; fi

echo -e "Copying binaries to a staging folder...\n"
cp -r "$1" infer-staging

# Run InferSharp analysis.
echo -e "Code translation started..."
/./infersharp/Cilsil/Cilsil translate infer-staging --outcfg infer-staging/cfg.json --outtenv infer-staging/tenv.json --cfgtxt infer-staging/cfg.txt --extprogress
echo -e "Code translation completed. Analyzing...\n"
infer run $infer_args --cfg-json infer-staging/cfg.json --tenv-json infer-staging/tenv.json

if [ ${github_sarif,,} == 'true' ]; then
    
    # Create backup
    cp infer-out/report.sarif infer-out/report.sarif.bak

    # fix https://github.com/microsoft/infersharpaction/issues/51
    sed -i 's/\"startColumn\":0/\"startColumn\":1/g' infer-out/report.sarif

    # replace sourcelink root _ path with ``
    sed -i 's/\"uri\":\"file:_\//\"uri\":\"/g' infer-out/report.sarif
    
    # replace file:home/runner/work/$GITHUB_REPOSITORY_NAME/$GITHUB_REPOSITORY_NAME/ path with ''
    prefix="$GITHUB_REPOSITORY_OWNER/"
    GITHUB_REPOSITORY_NAME=${GITHUB_REPOSITORY#"$prefix"}
    echo "$GITHUB_REPOSITORY_OWNER"
    echo "$GITHUB_REPOSITORY_NAME"
    command="s/\"uri\":\"file:home\/runner\/work\/$GITHUB_REPOSITORY_NAME\/$GITHUB_REPOSITORY_NAME\//\"uri\":\"/g"
    sed -i $command infer-out/report.sarif
fi

if [ "$output_folder" != "" ]; then
    if [ ! -d "$output_folder" ]; then
        mkdir "$output_folder"
    fi

    cp infer-out/report.sarif infer-out/report.txt $output_folder/
    echo -e "\nFull reports available at '$output_folder'\n"
fi