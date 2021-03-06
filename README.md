# kafka manager Dockerfile
[kafka manager](https://github.com/yahoo/kafka-manager) is a tool from Yahoo Inc. for managing [Apache Kafka](http://kafka.apache.org).
## Base Docker Image ##
* [centos:7](https://hub.docker.com/_/centos/)

## Howto
### Quick Start

```bash
docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="your-zk.domain:2181" -e APPLICATION_SECRET=letmein sheepkiller/kafka-manager
```

(if you don't define ZK_HOSTS, default value has been set to "localhost:2181")


### Use your own configuration file
Until 1.3.0.4, you were able to override default configuration file via a docker volume to overi:

```bash
docker run [...] -v /path/to/confdir:/kafka-manager-${KM_VERSION}/conf [...]
```

From > 1.3.0.4, you can specify a configuration file via an environment variable.

```bash
docker run [...] -v /path/to/confdir:/opt -e KM_CONFIG=/opt/my_shiny.conf sheepkiller/kafka-manager
```

### Pass arguments to kafka-manager
For release <= 1.3.0.4, you can pass options via command/args.

```bash
docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="your-zk.domain:2181" -e APPLICATION_SECRET=letmein sheepkiller/kafka-manager -Djava.net.preferIPv4Stack=true
```

For release > 1.3.0.4, you can use env variable `KM_ARGS`.

```bash
docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="your-zk.domain:2181" -e APPLICATION_SECRET=letmein -e KM_ARGS=-Djava.net.preferIPv4Stack=true sheepkiller/kafka-manager 
```

### Specify a revision
If you want to upgrade/downgrade this Dockerfile, edit it and set `KM_VERSION` and `KM_REVISION` to fetch the release from github.


## ToDo
- don't run kafka-manager as root
