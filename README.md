# Infer# GitHub Action

**Infer#** is an interprocedural and scalable static code analyzer for C#. Via the capabilities of Facebook's [Infer](https://fbinfer.com/), this tool detects null pointer dereferences and [resource leak](Examples/ResourceLeak/README.md). Its source code can be found [here](https://github.com/microsoft/infersharp).

![Sample Report](https://github.com/microsoft/infersharpaction/blob/main/assets/samplereport.png)

## Usage
```yml
- name: Run Infer#      
  uses: microsoft/infersharpaction@v1.0
  id: runinfersharp
  with:
    binary-path: '<path to the binary directory containing .dlls and .pdbs>'
- name: Infer# analysis results
  run: echo "${{ steps.runinfersharp.outputs.results }}"
```

### Parameters
#### `binary-path`
**Required** Path to the binary directory containing .dlls **and** .pdbs.

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
