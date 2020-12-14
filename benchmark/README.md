This repository is used to benchmark Spark performance on Azure Kubernetes Service. In this setup, we use Apache Spark and Hadoop binaries downloaded from apache.org.

You can also build your own image by downloading the Apache Spark distribution like those distributed by the Spark Downloads page and use ./dev/make-distribution.sh in the project root.

## Prerequisite

- Configure Azure Data Lake Gen2 Storage

Follow the steps listed [here](https://docs.microsoft.com/en-us/azure/storage/blobs/create-data-lake-storage-account) to configure the ADLS Gen2 storage account.


## Run benchmark
  - Generate the 1 TB data
    ```
    kubectl apply -f benchmark/spark-benchmark-generate-data.yaml
    ```
  - TPC-DS parameters

| argument                                    | value                   |
|---------------------------------------------|-------------------------|
| folder location to generate data            | ADLS Gen2 data location |
| tpcds tool kit location in the Docker image | /opt/tpcds-kit/tools    |
| file type                                   | parquet                 |
| data size                                   | 1000 for 1 TB           |

- Run TPC-DS queries
    ```
    kubectl apply -f benchmark/spark-benchmark-test.yaml
    ```

| argument                                    | value                   |
|---------------------------------------------|-------------------------|
| folder location to generate data            | ADLS Gen2 data location |
| tpcds tool kit location in the Docker image | /opt/tpcds-kit/tools    |
| file type                                   | parquet                 |
| data size                                   | 1000 for 1 TB           |

## Execution results

You can capture the query execution time using the pod logs or the output folder location.

  - Use Azure Storage Explorer [download here](https://azure.microsoft.com/en-us/features/storage-explorer/) to check execution results in ADLS Gen2 storage
  - Checking container logs
    ```
    kubectl logs <driver pod name>
    ```
