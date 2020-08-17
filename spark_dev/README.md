# spark_dev environment for Spark TPCDS tests running on AKS

Working repository for running spark TPCSDS benchmark on AKS

## spark_dev_env

Folder to create a container for spark TPCDS development.  This container will install the necessary tools (tpcds-toolkit, databricks tpcds library, spark 3.0, sbt) to build an application that will both generate TPCDS data and execute a benchmark upon this data.

## benchmarkcode

Folder with benchmark code.  Data generation and benchmark execution have been verified. Configuring for scale and Azure are remaining.

### TODO:

- [x] Verify data geneation on the local spark cluster (1GB data set)
- [x] Verify benchmark execution on the local spark cluster (1GB data set)
- [ ] Verify benchmark execution on a local kurbernetes cluster (1GB data set)
- [x] Generate 1GB data in Azure with an ABFS file system (can be an Azure VM), follow up on outcome
- [ ] Verify benchmark execution in Azure with an ABFS file system (can be an Azure VM)
- [?] Generate 1GB data in an Azure AKS clustser with ABFS file system
- [?] Verify benchmark execution in Azure AKS cluster with ABFS file system (1GB data)
- [ ] Prep envionment for 1TB benchmark, details TBD 
- [x] Generate 1TB data
- [ ] Run benchmark with 1TB data