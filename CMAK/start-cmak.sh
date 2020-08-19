#!/bin/sh

if [[ $KM_USERNAME != ''  && $KM_PASSWORD != '' ]]; then
    sed -i.bak '/^basicAuthentication/d' /cmak-${KM_VERSION}/conf/application.conf
    echo 'basicAuthentication.enabled=true' >> /cmak-${KM_VERSION}/conf/application.conf
    echo "basicAuthentication.username=${KM_USERNAME}" >> /cmak-${KM_VERSION}/conf/application.conf
    echo "basicAuthentication.password=${KM_PASSWORD}" >> /cmak-${KM_VERSION}/conf/application.conf
    echo 'basicAuthentication.realm="CMAK"' >> /cmak-${KM_VERSION}/conf/application.conf
fi

exec ./bin/cmak -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"