#  Run Benchmark
## Prerequisite

- Configure Azure Data Lake Gen2 Storage

Follow the steps listed [here](https://docs.microsoft.com/en-us/azure/storage/blobs/create-data-lake-storage-account) to configure the ADLS Gen2 storage account.


## Generate data
  - Generate the 1 TB data
  ````
  kubectl apply -f benchmark/spark-benchmark-generate-data.yaml
  ````
  - TPC-DS parameters

| argument                                    | value                   |
|---------------------------------------------|-------------------------|
| folder location to generate data            | ADLS Gen2 data location |
| tpcds tool kit location in the Docker image | /opt/tpcds-kit/tools    |
| file type                                   | parquet                 |
| data size                                   | 1000 for 1 TB           |

## Run benchmark
  ````
  kubectl apply -f benchmark/spark-benchmark-test.yaml
  ````

| argument                                    | value                   |
|---------------------------------------------|-------------------------|
| folder location to generate data            | ADLS Gen2 data location |
| tpcds tool kit location in the Docker image | /opt/tpcds-kit/tools    |
| file type                                   | parquet                 |
| data size                                   | 1000 for 1 TB           |

## Execution results

Capture the query execution time using the pod logs or the output folder location.

  - Use Azure Storage Explorer [download here](https://azure.microsoft.com/en-us/features/storage-explorer/) to check execution results in ADLS Gen2 storage
  - Checking container logs
  ````
  kubectl logs <driver pod name>
  ````
