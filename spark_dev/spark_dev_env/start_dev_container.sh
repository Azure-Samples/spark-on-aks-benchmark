#!/bin/bash

docker run -it --rm --mount source=app,destination=/opt/app -p 8080:8080 -p 8081:8081 -p 4040:80 --name spark_dev spark_dev:1.0 /bin/bash
