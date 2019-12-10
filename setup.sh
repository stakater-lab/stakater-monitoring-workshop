#!/bin/bash
set -x

DRY_RUN=$1

# Allow cluster-admin role to admin user to access dashboard
oc adm policy add-cluster-role-to-user cluster-admin admin

# Setup InfluxDB
oc apply -f infra/influx-db/ $DRY_RUN

# Setup Prometheus Forwarder to scrape Out of the Box Openshift Prometheus.
oc apply -f infra/prometheus-fwd/ $DRY_RUN