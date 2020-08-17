# TPC-DS AKS test container
Currently a work in progress

## The intention of this folder
* Create a spark container that can be used in the AKS environment and execute performance tests
  * This implies
    * Spark 3.0.0 container with Hadoop 3.2 (3.3 should be conidered) and a valid entrypoint
    * Scripts to kickoff benchmark in a kubernetes environment, both local and AKS