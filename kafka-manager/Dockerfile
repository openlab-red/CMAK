FROM centos:7

LABEL authors="Mattia Mascia <mmascia@redhat.com>"

RUN yum -y install java-1.8.0-openjdk-headless gettext nmap-ncat openssl

ENV JAVA_HOME=/usr/java/default/ \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.22 \
    KM_CONFIGFILE="conf/application.conf" \
    RUN_GROUP=kafka

RUN groupadd ${RUN_GROUP} \
    && useradd -r -m -u 1001 -g 0 ${RUN_GROUP}

RUN yum install -y java-1.8.0-openjdk-devel git wget unzip which \
    && mkdir -p /tmp \
    && cd /tmp \
    && git clone https://github.com/yahoo/kafka-manager -b ${KM_VERSION} --depth 1 \
    && cd /tmp/kafka-manager \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN unzip  -d / ./tmp/kafka-manager/target/universal/kafka-manager-${KM_VERSION}.zip \
    && rm -fr /tmp/* /root/.sbt /root/.ivy2 \
    && chmod +x /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN yum autoremove -y java-1.8.0-openjdk-devel git wget unzip which \
    && yum clean all -y

WORKDIR /kafka-manager-${KM_VERSION}

ENV HOME=/kafka-manager-${KM_VERSION}

RUN chown -R 1001:0 /kafka-manager-${KM_VERSION} \
    && chmod -R g+rw  /kafka-manager-${KM_VERSION}

EXPOSE 9000

USER 1001

ENTRYPOINT ["./start-kafka-manager.sh"]
