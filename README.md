[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/big-data-europe/Lobby)
[![Build Status](https://travis-ci.org/big-data-europe/docker-spark.svg?branch=master)](https://travis-ci.org/big-data-europe/docker-spark)
[![Twitter](https://img.shields.io/twitter/follow/BigData_Europe.svg?style=social)](https://twitter.com/BigData_Europe)
# Spark docker

Docker images to:
* Setup a standalone [Apache Spark](https://spark.apache.org/) cluster running one Spark Master and multiple Spark workers
* Build Spark applications in Java, Scala or Python to run on a Spark cluster

<details open>
<summary>Currently supported versions:</summary>

* Spark 3.3.0 for Hadoop 3.3 with OpenJDK 8 and Scala 2.12
* Spark 3.2.1 for Hadoop 3.2 with OpenJDK 8 and Scala 2.12
* Spark 3.2.0 for Hadoop 3.2 with OpenJDK 8 and Scala 2.12
* Spark 3.1.2 for Hadoop 3.2 with OpenJDK 8 and Scala 2.12
* Spark 3.1.1 for Hadoop 3.2 with OpenJDK 8 and Scala 2.12
* Spark 3.1.1 for Hadoop 3.2 with OpenJDK 11 and Scala 2.12
* Spark 3.0.2 for Hadoop 3.2 with OpenJDK 8 and Scala 2.12
* Spark 3.0.1 for Hadoop 3.2 with OpenJDK 8 and Scala 2.12
* Spark 3.0.0 for Hadoop 3.2 with OpenJDK 11 and Scala 2.12
* Spark 3.0.0 for Hadoop 3.2 with OpenJDK 8 and Scala 2.12
* Spark 2.4.5 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.4.4 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.4.3 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.4.1 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.4.0 for Hadoop 2.8 with OpenJDK 8 and Scala 2.12
* Spark 2.4.0 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.3.2 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.3.1 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.3.1 for Hadoop 2.8 with OpenJDK 8
* Spark 2.3.0 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.2.2 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.2.1 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.2.0 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.1.3 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.1.2 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.1.1 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.1.0 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.0.2 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.0.1 for Hadoop 2.7+ with OpenJDK 8
* Spark 2.0.0 for Hadoop 2.7+ with Hive support and OpenJDK 8
* Spark 2.0.0 for Hadoop 2.7+ with Hive support and OpenJDK 7
* Spark 1.6.2 for Hadoop 2.6 and later
* Spark 1.5.1 for Hadoop 2.6 and later

</details>

## Using Docker Compose

Add the following services to your `docker-compose.yml` to integrate a Spark master and Spark worker in [your BDE pipeline](https://github.com/big-data-europe/app-bde-pipeline):
```yml
version: '3'
services:
  spark-master:
    image: fcjbispo/fbnet-spark-master:3.4.1-hadoop3.3
    container_name: spark-master
    ports:
      - "8080:8080"
      - "7077:7077"
    environment:
      - INIT_DAEMON_STEP=setup_spark
  spark-worker-1:
    image: fcjbispo/fbnet-spark-worker:3.4.1-hadoop3.3
    container_name: spark-worker-1
    depends_on:
      - spark-master
    ports:
      - "8081:8081"
    environment:
      - "SPARK_MASTER=spark://spark-master:7077"
  spark-worker-2:
    image: fcjbispo/fbnet-spark-worker:3.4.1-hadoop3.3
    container_name: spark-worker-2
    depends_on:
      - spark-master
    ports:
      - "8082:8081"
    environment:
      - "SPARK_MASTER=spark://spark-master:7077"
  spark-history-server:
      image: fcjbispo/fbnet-spark-history-server:3.4.1-hadoop3.3
      container_name: spark-history-server
      depends_on:
        - spark-master
      ports:
        - "18081:18081"
      volumes:
        - /tmp/spark-events-local:/tmp/spark-events
```
Make sure to fill in the `INIT_DAEMON_STEP` as configured in your pipeline.

## Running Docker containers without the init daemon
### Spark Master
To start a Spark master:

    docker run --name spark-master -h spark-master -d fcjbispo/fbnet-spark-master:3.4.1-hadoop3.3

### Spark Worker
To start a Spark worker:

    docker run --name spark-worker-1 --link spark-master:spark-master -d fcjbispo/fbnet-spark-worker:3.4.1-hadoop3.3

## Launch a Spark application
Building and running your Spark application on top of the Spark cluster is as simple as extending a template Docker image. Check the template's README for further documentation.
* [Maven template](template/maven)
* [Python template](template/python)
* [Sbt template](template/sbt)

## Kubernetes deployment
The BDE Spark images can also be used in a Kubernetes enviroment.

To deploy a simple Spark standalone cluster issue

`kubectl apply -f https://raw.githubusercontent.com/big-data-europe/docker-spark/master/k8s-spark-cluster.yaml`

This will setup a Spark standalone cluster with one master and a worker on every available node using the default namespace and resources. The master is reachable in the same namespace at `spark://spark-master:7077`.
It will also setup a headless service so spark clients can be reachable from the workers using hostname `spark-client`.

Then to use `spark-shell` issue

`kubectl run spark-base --rm -it --labels="app=spark-client" --image fcjbispo/fbnet-spark-base:3.4.1-hadoop3.3 -- bash ./spark/bin/spark-shell --master spark://spark-master:7077 --conf spark.driver.host=spark-client`

To use `spark-submit` issue for example

`kubectl run spark-base --rm -it --labels="app=spark-client" --image fcjbispo/fbnet-spark-base:3.4.1-hadoop3.3 -- bash ./spark/bin/spark-submit --class CLASS_TO_RUN --master spark://spark-master:7077 --deploy-mode client --conf spark.driver.host=spark-client URL_TO_YOUR_APP`

You can use your own image packed with Spark and your application but when deployed it must be reachable from the workers.
One way to achieve this is by creating a headless service for your pod and then use `--conf spark.driver.host=YOUR_HEADLESS_SERVICE` whenever you submit your application.

## License
This project is licensed under the MIT License. For the full text of the license, see [the official MIT License](https://opensource.org/licenses/MIT).

---
## MIT License Disclaimer

Copyright (c) 2025 Francisco C J Bispo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.**

