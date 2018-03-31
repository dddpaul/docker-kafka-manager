FROM centos:7

MAINTAINER Pavel Derendyaev <dddpaul@gmail.com>

ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=162 \
    JAVA_VERSION_BUILD=12 \
    JAVA_URL_HASH=0da788060d494f5095bf8624735fa2f1 \
    JAVA_HOME=/usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.17 \
    KM_REVISION=0356db5f2698c36ec676b947c786b8543086dd49 \
    KM_CONFIGFILE="conf/application.conf"

RUN yum -y update && \
    yum install -y git wget unzip which && \
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=xxx; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_URL_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm" \
    -O /tmp/jdk-linux-x64.rpm && \
    yum -y install /tmp/jdk-linux-x64.rpm && \
    rm -f /tmp/jdk-linux-x64.rpm && \
    yum clean all

RUN mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    printf '#!/bin/sh\nexec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"\n' > /kafka-manager-${KM_VERSION}/km.sh && \
    chmod +x /kafka-manager-${KM_VERSION}/km.sh

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./km.sh"]
