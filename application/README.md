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

1. Replace the `NAMESPACE` placeholder with desired value in the `namespace.yaml` file, to create a new namespace using the command given below:

    ```bash
    oc apply -f namespace.yaml
    ```

    To check whether namespace is created or not:
    ```bash
    oc get namespaces | grep <namespace-name>
    ```

2. Once namespace is created, we will perform following operations: 

    2.1. Deploy monitoring services that exists in `infra/` directory.
    2.2. Deploy Nordmart application microservice that exists in `nordmart/` directory.  

3. Deploying Monitoring Infrastructure Services

    3.1 Deploy the Prometheus Operator using the manifests given in `/infra/operator/` directory. Follow the instructions one by one:

    3.1.1. Create a service account:
    
    ```bash
    oc apply -f serviceaccount.yaml
    ```
    To check whether serviceaccount is created or not:

    ```bash
    oc get serviceaccount -n <namespace> | grep <service-account>
    ```
    
    To get the manifest of the serviceaccount:
    ```bash
    oc get serviceaccount <service-account-name> -oyaml -n <namespace>
    ```

    3.1.2 Create clusterrole:

    ```bash
    oc apply -f clusterrole.yaml
    ```

    To check whether clusterrole is created or not:
    
    ```bash
    oc get clusterorle | grep <clusterrole>
    ```

    To get clusterrole manifest:

    ```bash
    oc get clusterrole <clusterrole> -oyaml
    ```
    
    ```
    MANIFEST
    ```

    3.1.3. Create clusterolebinding:

    ```bash
    oc apply -f clusterrolebinding.yaml
    ```

    To check whether clusterolebinding is created or not:
    
    ```bash
    oc get clusterolebinding | grep <clusterolebinding-name>
    ```
    
    To get clusterolebinding manifest:

    ```bash
    oc get clusterolebinding <clusterolebinding-name> -oyaml
    ```

    ```
    MANIFEST
    ```

    3.1.4. Deploy deployment:

    ```bash
    oc apply -f deployment.yaml -n <namespace>
    ```
    
    To check whether prometheus operator is deployed or not:
    ```bash
    oc get pod -n <namespace> | grep <pod-name>
    ```
    
    To get the manifest:

    ```bash
    oc get pod <pod-name> -oyaml -n <namespace>
    ```

    3.1.5. Create a service:

    ```bash
    oc apply -f service.yaml -n <namespace>
    ```

    To check whether service is created or not:
    ```bash
    oc get service -n <namespace> | grep <service-name>
    ```

    To get the service manifest:
    ```bash
    oc get service <service-name> -oyaml -n <namespace>
    ```

    3.1.6. Create service monitor:

    ```bash
    oc apply -f servicemonitor.yaml -n <namespace>
    ```

    ```bash
    oc get servicemonitor <servicemonitor-name> -n <namespace>
    ```

    ```bash
    oc get servicemonitor <servicemonitor-name> -oyaml -n <namespace>
    ```

    3.2. Deploy prometheus using the manifests given in `/infra/prometheus/` directory. Follow the instructions one by one:

    3.2.1. Create serviceaccount:

    ```bash
    oc apply -f serviceaccount.yaml -n <namespace>
    ```
    
    To check whether serviceaccount is created or not
    ```bash
    oc get serviceaccount -n <namespace> | grep <serviceaccount-name>
    ```

    To get the service account manifest

    ```bash
    oc get serviceaccount <serviceaccount-name> -oyaml -n <namespace>
    ```

    3.2.2 Create clusterrole:

    ```bash
    oc apply -f clusterrole.yaml
    ```

    To check whether clusterrole is created or not:
    
    ```bash
    oc get clusterorle | grep <clusterrole>
    ```

    To get clusterrole manifest:

    ```bash
    oc get clusterrole <clusterrole> -oyaml
    ```
    
    ```
    MANIFEST
    ```

    3.2.3. Create clusterolebinding:

    ```bash
    oc apply -f clusterrolebinding.yaml
    ```

    To check whether clusterolebinding is created or not:
    
    ```bash
    oc get clusterolebinding | grep <clusterolebinding-name>
    ```
    
    To get clusterolebinding manifest:

    ```bash
    oc get clusterolebinding <clusterolebinding-name> -oyaml
    ```

    ```
    MANIFEST
    ```

    3.2.4. Deploy prometheus:

    ```bash
    oc apply -f prometheus.yaml -n <namespace>
    ```
    
    To check whether prometheus operator is deployed or not:
    ```bash
    oc get pod -n <namespace> | grep <pod-name>
    ```
    
    To get the manifest:

    ```bash
    oc get pod <pod-name> -oyaml -n <namespace>
    ```

    3.2.5. Create prometheus service:

    ```bash
    oc apply -f service.yaml -n <namespace>
    ```

    To check whether service is created or not:
    ```bash
    oc get service -n <namespace> | grep <service-name>
    ```

    To get the service manifest:
    ```bash
    oc get service <service-name> -oyaml -n <namespace>
    ```

    3.2.5. Create prometheus route:

    ```bash
    oc apply -f route.yaml -n <namespace>
    ```

    ```bash
    oc get route -n <namespace> | grep <route-name>
    ```

    ```bash
    oc get route <route-name> -oyaml -n <namespace>
    ```

    3.2.6. Create secrets required by prometheus:

    ```bash
    oc apply -f prometheus-htpasswd.yaml -n <namespace>
    ```

    ```bash
    oc apply -f prometheus-tls.yaml -n <namespace>
    ```

    To check secrets are created or not:
    
    ```bash
    oc get secret -n <namespace>
    ```

    MANIFEST
















    3.3. Deploy grafana using the manifests given in `/infra/grafana/` directory. Follow the instructions one by one:

    3.3.1. Create serviceaccount:

    ```bash
    oc apply -f serviceaccount.yaml -n <namespace>
    ```
    
    To check whether serviceaccount is created or not
    ```bash
    oc get serviceaccount -n <namespace> | grep <serviceaccount-name>
    ```

    To get the service account manifest

    ```bash
    oc get serviceaccount <serviceaccount-name> -oyaml -n <namespace>
    ```

    3.3.2 Create role:

    ```bash
    oc apply -f role.yaml
    ```

    To check whether role is created or not:
    
    ```bash
    oc get role | grep <role>
    ```

    To get role manifest:

    ```bash
    oc get role <role> -oyaml
    ```
    
    ```
    MANIFEST
    ```

    3.3.3. Create rolebinding:

    ```bash
    oc apply -f rolebinding.yaml
    ```

    To check whether rolebinding is created or not:
    
    ```bash
    oc get rolebinding | grep <rolebinding-name>
    ```
    
    To get rolebinding manifest:

    ```bash
    oc get rolebinding <rolebinding-name> -oyaml
    ```

    ```
    MANIFEST
    ```

    3.3.4. Create configmap:
    
    ```bash
    oc apply -f configmap
    ```
    
    To check whether configmap is created or not:

    ```bash
    oc get configmap -n <namespace> | grep <configmap-name>
    ```

    To get configmap manifest:

    ```bash
    oc get configmap <configmap-name> -oyaml -n <namespace>
    ```

    3.3.5. Create grafana datasource config:

    ```bash
    oc apply -f datasources.yaml -n <namespace>
    ```

    ```bash
    oc get configmap -n <namespace> 
    ```

    ```bash
    oc get configmap <configmap-name> -oyaml -n <namespace>
    ```

    3.3.6. Create grafana dashboard config:

    ```bash
    oc apply -f grafana-dashboard.yaml -n <namespace>
    ```

    ```bash
    oc get configmap -n <namespace> | grep <config-map> 
    ```

    ```bash
    oc get configmap <configmap-name> -oyaml -n <namespace>
    ```
    
    3.3.7. Create grafana secret:

    ```bash
    oc apply -f secret.yaml -n <namespace>
    ```

    To check whether secret is created or not:
    ```bash
    oc get secret -n <namespace> 
    ```

    To get secret manifest:

    ```bash
    oc get secret <secret-name> -oyaml -n <namespace>
    ```

    3.3.8. Create grafana deployment:

    ```bash
    oc apply -f deployment.yaml -n <namespace>
    ```

    To check whether grafana has been deployed or not:

    ```bash
    oc get pod <pod-name> -n namespace.yaml
    ```

    To get the deployment manifest
    ```bash
    oc get pod <pod-name> -oyaml -n <namespace>
    ```

    3.3.9. Create a service for grafana:
    ```bash
    oc apply -f service,yaml -n <namespace>
    ```
    
    To check whether service created or not
    ```bash
    oc get service -n <namespace>
    ``` 

    To get the service manifest
    ```bash
    oc get service <service-name> -oyaml -n <namespace>
    ```
    
    3.3.10. Create route for grafana service to make it publically accessible:
    ```bash
    oc apply -f route.yaml -n <namespace>
    ```
    
    To check whether route is created or not
    ```bash
    oc get route -n <namespace>
    ```
    
    To get the route manifest:

    ```bash
    oc get route <route-name> -n <namespace>
    ```


4. Deploying Nordmart Application Microservices:

    4.1. Create a storage class:

    ```bash
    oc apply -f storage-class.yaml
    ```

    To check storage class is created

    ```
    oc get storageclass
    ```

    4.2. Each participant will create a new namespace and will use that namespace in later manifests:

    ```bash
    oc apply -f namespace.yaml
    ```

    Each participant can check whether namespace is created or not using the command given below:
    ```bash
    
    ```








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

