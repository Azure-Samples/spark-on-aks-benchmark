---
page_type: sample
languages:
  - Terraform, Bash
products:
  - Terraform, Spark, Kubernetes

description: "Add 150 character max description"
urlFragment: "update-this-to-unique-url-stub"
---

# Spark on Azure Kubernetes Service

<!--
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

## Build Status

| Status                                                                            |
| --------------------------------------------------------------------------------- |
| ![Terraform](https://github.com/Azure/spark-on-aks/workflows/Terraform/badge.svg) |

## Contents

| File/folder       | Description                                |
| ----------------- | ------------------------------------------ |
| `.github`         | Github specific configuration              |
| `aks-spark-chart` | Helm Charts                                |
| `benchmark`       | Benchmark test code                        |
| `docs`            | Project documentation                      |
| `env`             | Terraform to build environment             |
| `spark`           | Spark Docker containers and config         |
| `spark_dev`       |                                            |
| `.gitignore`      | Define what to ignore at commit time.      |
| `CODE_OF_CONDUCT.md` | Code of Conduct for this project        |
| `CHANGELOG.md`    | List of changes to the sample.             |
| `CONTRIBUTING.md` | Guidelines for contributing to the sample. |
| `README.md`       | This README file.                          |
| `LICENSE`         | The license for the sample.                |
___
## Introduction
[Apache Spark](http://spark.apache.org/) is popular distributed analytics engine designed to process large data sets through the use of distributed workers. This is a natural use-case for Kubernetes. The goal of this project is to evaluate and tune the performance of the Azure Kubernetes Service in running Spark.
___
## TPC-DS Benchmark
When evaluating platform configuration, the [TPC-DS](http://www.tpc.org/tpcds/default5.asp) benchmark was used to measure performance.
<!-- TODO: Add more info about the Benchmark -->
## Getting Started
Follow [these instructions](docs/quick-start-guide.md) for running the benchmark against AKS.
___
## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
