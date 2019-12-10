# Infrastrucutre Monitoring Guidelines

## Overview
This document provides the guidelines to deploy Prometheus Forwarder that fetches metrices from prometheus (deployed with default openshift-monitoring) and forward it to influxDB.


## Folder Structure Description

```bash
├── influx-db                 # Folder containing manifests to deploy InfluxDB  
│   ├── config.yaml
│   ├── init-config.yaml
│   ├── namespace.yaml
│   ├── service.yaml
│   └── statefulset.yaml
├── prometheus-fwd            # Folder containing prometheus forwarder to scrape default prometheus 
│   ├── prom-forwarder.yaml
│   ├── route-prom-fwd.yaml
│   ├── service-k8s2.yaml
│   ├── servicemonitor.yaml
│   └── service-route.yaml
└── README.md
```

## Deployment Guidelines 

Follow the guidelines given below to deploy InfluxDB:

1. We will deploy our influxDB instance in a separate namespace called `storage`. To create this namespace run the following
    ```bash
    cd influx-db
    ```

    ```bash
    oc apply -f namespace.yaml
    ```

    To check whether namespace is created or not:
    ```bash
    oc get namespaces | grep storage
    ```

2. Once namespace is created, we will perform following operations:

    - Deploy necessary configs for influx db
    - Deploy influxdb statefulset
    - Deploy a service for influxdb statefulset

3. Deploying Configs for InfluxDB

    Deploy the init-config which will run when influxdb is instantiating using the manifests given in `/influx-db/` directory. Follow the instructions one by one:

    3.1 Create an init-config.yaml:
    
    ```bash
    oc apply -f init-config.yaml
    ```
    To check whether the ConfigMap is created or not:

    ```bash
    oc get configmap -n storage | grep influxdb-init
    ```
    
    To get the manifest of the configmap:
    ```bash
    oc get configmap influxdb-init -o yaml -n storage
    ```

    3.2 Create configmap for influxdb.

    ```bash
    oc apply -f config.yaml
    ```

    To check whether configmap is created or not:
    
    ```bash
    oc get configmap -n storage | grep influxdb
    ```

    To get configmap manifest:

    ```bash
    oc get configmap influxdb -n storage -o yaml 
    ```

    3.3 Create statefulset for influxdb.

    ```bash
    oc apply -f statefulset.yaml
    ```

    To check whether statefulset is created or not:
    
    ```bash
    oc get statefulset -n storage | grep influxdb
    ```

    To get statefulset manifest:

    ```bash
    oc get statefulset influxdb -o yaml -n storage
    ```

    3.4 Create service for influxdb.

    ```bash
    oc apply -f service.yaml
    ```

    To check whether service is created or not:
    
    ```bash
    oc get service -n storage | grep influxdb
    ```

    To get service manifest:

    ```bash
    oc get service influxdb -n storage -o yaml
    ```
Now the influxdb should be accessible to other services via name `influxdb.storage.svc` on port `8086`


4. Now we will deploy prometheus that will scrape default prometheus and forward it to influxdb. Follow these steps to deploy `prometheus-forwarder` in the directory `prometheus-fwd/`

    ```bash
    cd ../prometheus-fwd
    ```

   4.1 Create a Prometheus custom Resource instance:
    
    ```bash
    oc apply -f prom-forwarder.yaml
    ```
    To check whether the prometheus instance is created or not:

    ```bash
    oc get prometheus -n openshift-monitoring | grep prometheus-forwarder
    ```
    
    To get the manifest of the prometheus:
    ```bash
    oc get prometheus prometheus-forwarder -o yaml -n openshift-monitoring
    ```

   4.2 Create a service to select newly created prometheus pods:
    
    ```bash
    oc apply -f service-k8s2.yaml
    ```
    To check whether the service is created or not:

    ```bash
    oc get service -n openshift-monitoring | grep prometheus-k8s2
    ```
    
    To get the manifest of the service:
    ```bash
    oc get service prometheus-k8s2 -o yaml -n openshift-monitoring
    ```

   4.3 Create a service for route:
    
    ```bash
    oc apply -f service-route.yaml
    ```
    To check whether the service is created or not:

    ```bash
    oc get service -n openshift-monitoring | grep prometheus-forwarder
    ```
    
    To get the manifest of the service:
    ```bash
    oc get service prometheus-forwarder -o yaml -n openshift-monitoring
    ```

   4.4 Create a route:
    
    ```bash
    oc apply -f route-prom-fwd.yaml
    ```
    To check whether the route is created or not:

    ```bash
    oc get route -n openshift-monitoring | grep prometheus-forwarder
    ```
    
    To get the manifest of the route:
    ```bash
    oc get route prometheus-forwarder -o yaml -n openshift-monitoring
    ```

    4.5 Create a Service Monitor to dynamically update config for prometheus:
    ```bash
    oc apply -f servicemonitor.yaml
    ```
    To check whether the service monitor is created or not:

    ```bash
    oc get servicemonitor -n openshift-monitoring | grep prometheus-forwarder
    ```
    
    To get the manifest of the service monitor:
    ```bash
    oc get servicemonitor prometheus-forwarder -o yaml -n openshift-monitoring
    ```
When the Prometheus pod is up goto the URL `prometheus-forwarder.cp-stakater.com` to check whether the prometheus-forwarder is scraping the old prometheus under `status -> targets`.

The metrices scraped from the default prometheus will be forwareded to InfluxDB deployed in the `storage` namespace

Influx DB will have nothing in it initially. Once Influx DB is deployed we will create a database named prometheus in it.
1.  To get the pods in storage database:
```bash
oc get pod -n storage
```
2. To enter the prometheus database:
```bash
oc -n storage exec -it <pod-name> /bin/sh
```
3. To start the influx shell:
```bash
influx
```
4. To get the existing databases:
```bash
show databases
```
5. To get the measurements:
```bash
show measurements
```
The measurement acts as a container for tags, fields, and the time column.

6. Create `prometheus` database. (Already created by init-configmap while installing influx)
7. To check whether measurements exists in `prometheus` or not:
```bash
show databases
use prometheus
show measurements
```