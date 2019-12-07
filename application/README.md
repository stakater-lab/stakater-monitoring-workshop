# Application Deployment Guidelines

## Overview
This document provides the guidelines to deploy Nordmart Application with its required dependencies.


## Folder Structure Description

```bash

├── deploy-apps-monitoring.sh  # To create application monitoring services and nordmart application
│
├── destroy-apps-monitoring.sh # To delete application monitoring services and nordmart application 
│
│
├── infra  # It contains application monitoring infrastructure
│   │
│   ├── operator  # It contains prometheus operator manifests
│   │   ├── clusterrolebinding.yaml
│   │   ├── clusterrole.yaml
│   │   ├── deployment.yaml
│   │   ├── serviceaccount.yaml
│   │   ├── servicemonitor.yaml
│   │   └── service.yaml
│   │
│   │
│   └── prometheus  # It contains prometheus manifests
│       ├── clusterrole.yaml
|       ├── clusterrolebinding.yaml
|       ├── prometheus-htpasswd.yaml
|       ├── prometheus-proxy.yaml
|       ├── prometheus-tls.yaml
|       ├── prometheus.yaml
│       ├── rolebinding.yaml
│       ├── role.yaml
│       ├── route.yaml
│       ├── serviceaccount.yaml
|       └── service.yaml
│      
│
├── namespace.yaml  # It contains namespace manifest
│
│
├── nordmart  # It contains manifests for Nordmart Application
|
|   # Prometheus specific configuration
│   ├── catalog-prometheus-rule.yaml
│   ├── catalog-service-dashboard.yaml
│   ├── catalog-service-monitor.yaml
|
|   # Application specific configuration
│   ├── clusterrolebinding.yaml
│   ├── clusterrole.yaml
│   ├── serviceaccount.yaml
|
|   # Normart Application Microservice
│   ├── cart.yaml
│   ├── catalog.yaml
│   ├── gateway.yaml
│   ├── inventory.yaml
│   ├── web.yaml
│   ├── review.yaml
|
|   # Database Manifests
│   ├── mongo.yaml
│   ├── mysql-secret.yaml
│   ├── mysql.yaml
|
|   # Nordmart Application Microservices
│   ├── route-gateway.yaml
│   └── route-web.yaml
│
|
|   # Documentation
├── README.md
|    
|   # Bash Scripts to replace the NAMESPACE placeholder in all manifests with user specified value
├── setup-vars.sh
|
|   # Storage Class manifest
└── storage-class.yaml

```

## Deployment Guidelines 

Follow the guidelines given below to deploy the application:

1. Change value of `NAMESPACE` variable in `deploy-apps-monitoring.sh` file.

2. Use the command given below to deploy the application:

    ```bash
    ./deploy-apps-monitoring.sh
    ```

    Above script performs following tasks:

    2.1. Replace namespace:
    
    ```bash
    # Setup vars for individual namespaces
    ./setup-vars.sh $NAMESPACE
    ```

    2.2. Create namespace:
    
    ```bash
    # Create Namespace
    oc apply -f namespace.yaml
    ```

    2.3. Storage class creation:
    
    ```bash
    # Create storage class 
    oc apply -f storage-class.yaml
    ```

    2.4. Deploy monitoring services:
    ```bash
    # Deploy Monitoring
    ## Deploy Prometheus Operator
    oc apply -f infra/operator/.

    ## Deploy Prometheus
    oc apply -f infra/prometheus/.
    ```

    2.5. Deploy Nordmart microservices:
    ```bash
    # Deploy Nordmart Services
    oc apply -f nordmart/.
    ```

3. Use the command given below to destroy services and namespaces:
    ```bash
    # Destroy Application monitroing services
    ./destroy-apps-monitoring.sh
    ```
    
    Above script performs following tasks:

    3.1. Delete the Nordmart application

    ```bash
    # Destroy Nordmart Services
    oc delete -f nordmart/.
    ```

    3.2. Delete the prometheus:
    
    ```bash
    ## Destroy Prometheus
    oc delete -f infra/prometheus/.
    ```

    3.3. Delete prometheus operator:
    
    ```bash
    ## Destroy Prometheus Operator
    oc delete -f infra/operator/.
    ```

    3.4. Delete the storage class:
    ```bash
    ## Destroy storage class
    oc apply -f storage-class.yaml
    ```

    3.5. Delete namespace:
    ```bash
    # Destroy namespace
    oc delete -f namespace.yaml
    ```

