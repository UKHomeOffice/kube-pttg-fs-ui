#!/usr/bin/env bash
export KUBE_NAMESPACE=${KUBE_NAMESPACE}
export ENVIRONMENT=${ENVIRONMENT}
export APP=pttg-fs-ui
export KUBE_SERVER=${KUBE_SERVER_DEV}
export KUBE_TOKEN=${KUBE_TOKEN}

cd kd
kd --insecure-skip-tls-verify --timeout 300\
   --file ${ENVIRONMENT}/pttg-fs-ui-deployment.yaml \
   --file ${ENVIRONMENT}/pttg-fs-ui-ingress.yaml \
   --file ${ENVIRONMENT}/pttg-fs-ui-svc.yaml