# Destroy Nordmart Services
oc delete -f nordmart/.

## Destroy Prometheus
oc delete -f infra/prometheus/.

## Destroy Prometheus Operator
oc delete -f infra/operator/.

# Destroy namespace
oc delete -f namespace.yaml