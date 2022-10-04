# Infer# GitHub Action

**Infer#** is an interprocedural and scalable static code analyzer for C#. Via the capabilities of Facebook's [Infer](https://fbinfer.com/), this tool detects race condition, null pointer dereferences and resource leaks. It also performs taint flow tracking to detect critical security vulnerabilities like SQL injections. Its source code can be found [here](https://github.com/microsoft/infersharp).

![Sample Report](https://github.com/microsoft/infersharpaction/blob/main/assets/samplereport.png)

## Usage

### Option 1 - Uploading [SARIF](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning) output to GitHub
```yml
- name: Run Infer#      
  uses: microsoft/infersharpaction@v1.4
  id: runinfersharp
  with:
    binary-path: '<path to the binary directory containing .dlls and .pdbs>'

- name: Upload SARIF output to GitHub Security Center
  uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: infer-out/report.sarif
```
You can view and manage the results at the Security tab -> Code scanning alerts. For example, if an alert is a false positive, you can dismiss it. Next time code scanning runs, the same code won't generate an alert.
For all supported features, please see GitHub Docs on [managing alerts](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/managing-code-scanning-alerts-for-your-repository).

### Option 2 - Displaying results directly in workflow logs
```yml
- name: Run Infer#      
  uses: microsoft/infersharpaction@v1.4
  id: runinfersharp
  with:
    binary-path: '<path to the binary directory containing .dlls and .pdbs>'

- name: Infer# analysis results
  run: echo "${{ steps.runinfersharp.outputs.results }}"
```

### Option 3 - Uploading results as an artifact
```yml
- name: Run Infer#      
  uses: microsoft/infersharpaction@v1.4
  id: runinfersharp
  with:
    binary-path: '<path to the binary directory containing .dlls and .pdbs>'

- name: Upload Infer# report as an artifact
  uses: actions/upload-artifact@v2
  with:
    name: report
    path: infer-out/report.txt
```

## Parameters
### `binary-path`
**Required** Path to the binary directory containing .dlls **and** .pdbs.

### `optional-flags`
See https://fbinfer.com/docs/man-infer-run/#OPTIONS for the complete list.

You can concatenate multiple flags with space.

## Limitations
- GitHub does not currently support Linux containers hosted on Windows; your CI pipeline must run on Linux. If it doesn't, you may still apply the analyzer by creating a dependent workflow which transports the binaries to a Linux host on which to run the analysis.

- If the project is too large, the analysis may time out.

- The analyzer may report warnings outside of your own code. This is because it runs on all input .pdbs, including those belonging to third-party library references. To prevent this, isolate the desired binaries in the input `binary-path` directory.

## Troubleshooting
- Please see [here](https://github.com/microsoft/infersharp/blob/main/TROUBLESHOOTING.md) for troubleshooting tips.

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
