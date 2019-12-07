#!/bin/bash
set -x

NAMESPACE=$1

sed -i -e "s/NAMESPACE/${NAMESPACE}/g" namespace.yaml

sed -i -e "s/NAMESPACE/${NAMESPACE}/g" infra/operator/*
sed -i -e "s/NAMESPACE/${NAMESPACE}/g" infra/prometheus/*

sed -i -e "s/NAMESPACE/${NAMESPACE}/g" nordmart/*
