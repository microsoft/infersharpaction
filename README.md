# C# Code Analyzer

**C# Code Analyzer** is an interprocedural and scalable static code analyzer for C#. Via the capabilities of Facebook's [Infer](https://fbinfer.com/), this tool detects null pointer dereferences and [resource leak](Examples/ResourceLeak/README.md). Its source code can be found at https://github.com/microsoft/infersharp.

![alt text](https://github.com/microsoft/CSharpCodeAnalyzer/blob/master/assets/samplereport.png "Sample Report")

## Basic Usage
```yml
- name: Run C# Code Analyzer      
  uses: microsoft/CSharpCodeAnalyzer@v0.1-beta
  id: runcsharpcodeanalyzer
  with:
    binary-path: '<path to the binary directory containing .dlls and .pdbs>'
- name: C# Code Analyzer analysis results
  run: echo "${{ steps.runcsharpcodeanalyzer.outputs.results }}"
```

### Parameters
#### `binary-path`
**Required** Path to the binary directory containing .dlls **and** .pdbs.

#### `report-on-files`
By default, the analyzer will report issues on all input binaries set to `binary-path`. If you prefer to see the warnings on a specific set of files (for example, changed files in a PR), provide a list of file paths delimited either by spaces or commas; for example, _src/project1/class1.cs,src/project2/class2.cs_.

## Report On Changed Files Only From PRs
The tool can be tuned to analyze only the changed files in a pull request. To do this, select any Github Action which retrieves the changed files in a pull request (for example, [Get All Changed Files Action](https://github.com/marketplace/actions/get-all-changed-files)) and configure it to `report-on-files` as follows:
```yml
- name: Get All Changed Files
  id: files
  uses: jitterbit/get-changed-files@v1
- name: Run C# Code Analyzer      
  uses: microsoft/CSharpCodeAnalyzer@v0.1-beta
  id: runcsharpcodeanalyzer
  with:
    binary-path: '<path to the binary directory where it contains .dlls and .pdbs>'
    report-on-files: ${{ steps.files.outputs.all }}
- name: C# Code Analyzer analysis results
  run: echo "${{ steps.runcsharpcodeanalyzer.outputs.results }}"
```

## Limitations
- GitHub does not currently support Linux containers hosted on Windows; your CI pipeline must run on Linux. If it doesn't, you may still apply the analyzer by creating a dependent workflow which transports the binaries to a Linux host on which to run the analysis.

- If the project is too large, the analysis may time out.

- The analyzer may report warnings outside of your own code. This is because it runs on all input .pdbs, including those belonging to third-party library references. To prevent this, isolate the desired binaries in the input `binary-path` directory.

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