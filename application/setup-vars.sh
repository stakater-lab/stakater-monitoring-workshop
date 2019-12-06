#!/bin/bash
set -x

NAMESPACE:= nordmart-monitoring

sed -i -e 's/NAMESPACE/$NAMESPACE/g' infra/operator/*
sed -i -e 's/NAMESPACE/$NAMESPACE/g' infra/prometheus/*

# Deploy Prometheus Operator
oc apply -f operator/*

# Deploy Prometheus
oc apply -f prometheus/*
