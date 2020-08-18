# TPC-DS AKS test container
Currently a work in progress

## The intention of this folder
* Create a spark container that can be used in the AKS environment and execute performance tests
  * This implies
    * Spark 3.0.0 container with Hadoop 3.2 (3.3 should be conidered) and a valid entrypoint
    * Scripts to kickoff benchmark in a kubernetes environment, both local and AKS

## MISC NOTES Only - authentication choices

## Service Principle
spark.conf.set("fs.azure.account.auth.type.myadlsgen2.dfs.core.windows.net", "OAuth") 
spark.conf.set("fs.azure.account.oauth.provider.type.myadlsgen2.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
spark.conf.set("fs.azure.account.oauth2.client.id.myadlsgen2.dfs.core.windows.net", "<<application ID GUID>>") 
spark.conf.set("fs.azure.account.oauth2.client.secret.myadlsgen2.dfs.core.windows.net", dbutils.secrets.get(scope = "mysecretscope", key = "adlsgen2secret"))
spark.conf.set("fs.azure.account.oauth2.client.endpoint.myadlsgen2.dfs.core.windows.net", "https://login.microsoftonline.com/<<AADt id>>/oauth2/token")

fs.azure.account.auth.type	OAuth
fs.azure.account.oauth.provider.type	org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider
fs.azure.account.oauth2.client.endpoint	Provide your tenant ID: https://login.microsoftonline.com/<Tenant_ID>/oauth2/token
fs.azure.account.oauth2.client.id	Provide your <Client_ID>
fs.azure.account.oauth2.client.secret	Provide your <Client_Secret>

## Key
spark.conf.set("fs.azure.account.key.jamesposparkdata.dfs.core.windows.net","mykey") 
spark.read.csv("abfss://tpcds@jamesposparkdata.dfs.core.windows.net/results/hello.csv").count
