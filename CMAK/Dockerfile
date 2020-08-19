FROM registry.redhat.io/ubi7/ubi:latest

LABEL authors="Mattia Mascia <mmascia@redhat.com>"

RUN yum -y install --disableplugin=subscription-manager java-11-openjdk-headless gettext nmap-ncat openssl

ENV JAVA_HOME=/usr/java/default/ \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=3.0.0.5 \
    KM_CONFIGFILE="conf/application.conf" \
    RUN_GROUP=kafka

RUN groupadd ${RUN_GROUP} \
    && useradd -r -m -u 1001 -g 0 ${RUN_GROUP}

RUN yum install -y java-1.11.0-openjdk-devel git wget unzip which \
    && mkdir -p /tmp \
    && cd /tmp \
    && git clone https://github.com/yahoo/CMAK -b ${KM_VERSION} --depth 1 \
    && cd /tmp/CMAK \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist

ADD start-cmak.sh /cmak-${KM_VERSION}/start-cmak.sh

RUN unzip  -d / ./tmp/CMAK/target/universal/cmak-${KM_VERSION}.zip \
    && rm -fr /tmp/* /root/.sbt /root/.ivy2 \
    && chmod +x /cmak-${KM_VERSION}/start-cmak.sh

RUN yum autoremove -y java-11-openjdk-devel git wget unzip which \
    && yum clean all -y

WORKDIR /cmak-${KM_VERSION}

ENV HOME=/cmak-${KM_VERSION}

RUN chown -R 1001:0 /cmak-${KM_VERSION} \
    && chmod -R g+rw  /cmak-${KM_VERSION}

EXPOSE 9000

USER 1001

ENTRYPOINT ["./start-cmak.sh"]
