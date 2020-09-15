<!-- TODO: Add info on how to deploy this chart via Helm in a local development environment -->

## What is deployed in this chart ##

* Loki Monitoring Stack
    Loki
    Promtail
    Grafana
    Prometheus


## Using Grafana
The following command is used to get the admin password for Grafana
```
kubectl get secret spark-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

To access the Grafana UI, run the following command:
```
kubectl port-forward service/spark-grafana 3000:80
```

Then navigate to [http://localhost:3000](http://localhost:3000) and login with `admin` and the password output above.