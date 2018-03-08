#!/bin/bash

export KUBE_NAMESPACE=${KUBE_NAMESPACE}
export KUBE_SERVER=${KUBE_SERVER}

if [[ -z ${VERSION} ]] ; then
    export VERSION=${IMAGE_VERSION}
fi

if [[ ${ENVIRONMENT} == "prod" ]] ; then
    echo "deploy ${VERSION} to prod namespace, using PTTG_FS_PROD drone secret"
    export KUBE_TOKEN=${PTTG_FS_PROD}
else
    if [[ ${ENVIRONMENT} == "test" ]] ; then
        echo "deploy ${VERSION} to test namespace, using PTTG_FS_TEST drone secret"
        export KUBE_TOKEN=${PTTG_FS_TEST}
    else
        echo "deploy ${VERSION} to dev namespace, using PTTG_FS_DEV drone secret"
        export KUBE_TOKEN=${PTTG_FS_DEV}
    fi
fi

if [[ -z ${KUBE_TOKEN} ]] ; then
    echo "Failed to find a value for KUBE_TOKEN - exiting"
    exit -1
fi

export WHITELIST=${WHITELIST:-0.0.0.0/0}

if [ "${ENVIRONMENT}" == "prod" ] ; then
    export DNS_PREFIX=
    export KC_REALM=pttg-production
else
    export DNS_PREFIX=${ENVIRONMENT}.notprod.
    export KC_REALM=pttg-qa
fi

cd kd

kd --insecure-skip-tls-verify \
    -f networkPolicy.yaml \
    -f ingress.yaml \
    -f deployment.yaml \
    -f service.yaml