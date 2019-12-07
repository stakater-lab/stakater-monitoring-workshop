#!/bin/bash
set -x

NAMESPACE=test-prom # Change with REPLACE_ME

# Setup vars for individual namespaces
./setup-vars.sh $NAMESPACE

# Create Namespace
oc apply -f namespace.yaml

# Deploy Monitoring
## Deploy Prometheus Operator
oc apply -f infra/operator/.

## Deploy Prometheus
oc apply -f infra/prometheus/.

# Deploy Nordmart Services
#oc apply -f nordmart/.
