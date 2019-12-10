# Destroy Nordmart Services
oc delete -f nordmart/.

## Deploy Grafana
oc delete -f infra/grafana/.

## Destroy Prometheus
oc delete -f infra/prometheus/.

## Destroy Prometheus Operator
oc delete -f infra/operator/.

## Destroy storage class
oc delete -f storage-class.yaml

# Destroy namespace
oc delete -f namespace.yaml