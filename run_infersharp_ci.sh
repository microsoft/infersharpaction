#!/bin/bash

# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

set -e

# Check if we have enough arguments.
if [ "$#" -lt 1 ]; then
    echo "run_infersharp.sh <dll_folder_path> [--output-folder <sarif_output_folder_path> --enable-null-dereference --enable-dotnet-resource-leak --enable-thread-safety-violation] -- requires 1 argument (dll_folder_path)"
    exit
fi

infer_args_list=("--enable-issue-type NULLPTR_DEREFERENCE" "--enable-issue-type DOTNET_RESOURCE_LEAK" "--enable-issue-type THREAD_SAFETY_VIOLATION")
output_folder=""
fail_on_issue=false

# Clear issue types if specific issue is mentioned in arguments
for v in "$@"
do
    if [[ $v == --enable* ]]; then
        infer_args_list=()
    fi
done

# Parse arguments
if [ "$#" -gt 1 ]; then
    i=2
    while [ $i -le $# ]
    do
        if [ ${!i} == "--enable-null-dereference" ]; then
            infer_args_list+=("--enable-issue-type NULLPTR_DEREFERENCE")
        elif [ ${!i} == "--enable-dotnet-resource-leak" ]; then
            infer_args_list+=("--enable-issue-type DOTNET_RESOURCE_LEAK")
        elif [ ${!i} == "--enable-thread-safety-violation" ]; then
            infer_args_list+=("--enable-issue-type THREAD_SAFETY_VIOLATION")
        elif [ ${!i} == "--fail-on-issue" ]; then
            fail_on_issue=true
        elif [ ${!i} == "--output-folder" ]; then
            ((i++))
            output_folder=${!i}
        fi
        ((i++))
    done
fi

# Dynamically create the issue types
infer_args=""
for infer_arg in "${infer_args_list[@]}"
do
    infer_args="$infer_args $infer_arg"
done

echo "Processing {$1}"
# Preparation
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
if [ -d infer-out ]; then rm -Rf infer-out; fi
if [ -d infer-staging ]; then rm -Rf infer-staging; fi

echo -e "Copying binaries to a staging folder...\n"
cp -r "$1" infer-staging

# Run InferSharp analysis.
echo -e "Code translation started..."
/./infersharp/Cilsil/Cilsil translate infer-staging --outcfg infer-staging/cfg.json --outtenv infer-staging/tenv.json --cfgtxt infer-staging/cfg.txt --extprogress
echo -e "Code translation completed. Analyzing...\n"
infer capture 
mkdir infer-out/captured 
infer $(infer help --list-issue-types 2> /dev/null | grep ':true:' | cut -d ':' -f 1 | sed -e 's/^/--disable-issue-type /') $infer_args --pulse --no-biabduction --debug-level 1 --sarif analyzejson --cfg-json infer-staging/cfg.json --tenv-json infer-staging/tenv.json

if [ "$output_folder" != "" ]; then
    if [ ! -d "$output_folder" ]; then
        mkdir "$output_folder"
    fi

    cp infer-out/report.sarif infer-out/report.txt $output_folder/
    echo -e "\nFull reports available at '$output_folder'\n"
fi

if [ "$fail_on_issue" == true ]; then
    if [ -s infer-out/report.txt ]; then
        echo -e "\n--fail-on-issue flag ON, exit code set to 1.\n"
        exit 1
    fi
fi
