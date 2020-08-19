FROM centos:7

LABEL authors="Mattia Mascia <mmascia@redhat.com>"

RUN yum -y install java-1.8.0-openjdk-headless gettext nmap-ncat openssl

ENV JAVA_HOME=/usr/java/default/ \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=3.0.0.5 \
    KM_CONFIGFILE="conf/application.conf" \
    RUN_GROUP=kafka

RUN groupadd ${RUN_GROUP} \
    && useradd -r -m -u 1001 -g 0 ${RUN_GROUP}

RUN yum install -y java-1.8.0-openjdk-devel git wget unzip which \
    && mkdir -p /tmp \
    && cd /tmp \
    && git clone https://github.com/yahoo/CMAK -b ${KM_VERSION} --depth 1 \
    && cd /tmp/CMAK \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist

ADD start-CMAK.sh /CMAK-${KM_VERSION}/start-kafka-manager.sh

RUN unzip  -d / ./tmp/CMAK/target/universal/CMAK-${KM_VERSION}.zip \
    && rm -fr /tmp/* /root/.sbt /root/.ivy2 \
    && chmod +x /CMAK-${KM_VERSION}/start-CMAK.sh

RUN yum autoremove -y java-1.8.0-openjdk-devel git wget unzip which \
    && yum clean all -y

WORKDIR /CMAK-${KM_VERSION}

ENV HOME=/CMAK-${KM_VERSION}

RUN chown -R 1001:0 /CMAK-${KM_VERSION} \
    && chmod -R g+rw  /CMAK-${KM_VERSION}

EXPOSE 9000

USER 1001

ENTRYPOINT ["./start-CMAK.sh"]
