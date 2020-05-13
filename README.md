# C# Code Analyzer

**C# Code Analyzer** is an inter-procedural and scalable static code analyzer for C#. We are bringing the capability of [Facebook's Infer](https://fbinfer.com/) into the .NET world. Currently it supports null pointer exception and resource leak.

![alt text](https://github.com/microsoft/CSharpCodeAnalyzer/blob/master/assets/samplereport.png "Sample Report")

## Basic Usage
```yml
- uses: microsoft/csharpcodeanalyzer@v0.1-beta
  with:
    binary-path: '<path to the binary directory where it contains .dlls and .pdbs>'
    repository: ${{ github.repository }}
- name: C# Code Analyzer analysis results
  run: echo "${{ steps.runcsharpcodeanalyzer.outputs.results }}"
```

### Parameters
#### `binary-path`
**Required** Path to the binary directory where it contains .dlls **and** .pdbs.

#### `changed-files`
By default, the analyzer will report issues on all input binaries set to `binary-path`. If you prefer to show the warnings coming from a specific set of files (for example, changed files in a PR), provide a list of file paths in either space or comma delimited format, for example, _src/project1/class1.cs,src/project2/class2.cs_.

#### `opt-out-telemetry`
Your code or artifacts will never leave GitHub. We only collect non-sensitive information on the tool usage itself to help us improve the analyzer. Set to `true` if you would like to opt out.

## Report On Changed Files Only From PRs
You can leverage any GitHub Action that gets all changed file paths from a PR (for example, [Get All Changed Files Action](https://github.com/marketplace/actions/get-all-changed-files)) and set it to `changed-files` like the following:
```yml
- name: Get All Changed Files
  id: files
  uses: jitterbit/get-changed-files@v1
- uses: microsoft/csharpcodeanalyzer@v0.1-beta
  with:
    binary-path: '<path to the binary directory where it contains .dlls and .pdbs>'
    repository: ${{ github.repository }}
    changed-files: ${{ steps.files.outputs.all }}
- name: C# Code Analyzer analysis results
  run: echo "${{ steps.runcsharpcodeanalyzer.outputs.results }}"
```

## Limitations
- GitHub does not support hosting Linux containers on Windows at the time of this writing. Your CI pipeline needs to run on Linux. If your current CI pipeline runs on Windows, however, you can create a dependent workflow, using artifacts to transport the binaries to another Linux host to run the analysis.

## Known Issues
- We don't have control over the build agents. If the project is too big, the analysis may time out. We are working on the next version to address this.

- You may find warnings that are not from your own code, because the third-party libraries that the project references may contain .pdb files which will be analyzed as well. You may choose to either remove those unwanted .pdb files, or copy only the desired binaries to another directory and pass it to `binary-path` to exclude the unwanted analysis.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
