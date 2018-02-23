#!/bin/bash
export KUBE_NAMESPACE=${KUBE_NAMESPACE}
export KUBE_SERVER=${KUBE_SERVER}
export KUBE_TOKEN=${KUBE_TOKEN}
export WHITELIST=${WHITELIST:-0.0.0.0/0}

if [ $ENVIRONMENT == "prod" ]
then
    export KUBE_TOKEN=${PROD_KUBE_TOKEN}
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