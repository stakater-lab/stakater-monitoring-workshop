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
│       ├── clusterrolebinding.yaml
│       ├── prometheus-htpasswd.yaml
│       ├── prometheus-proxy.yaml
│       ├── prometheus-tls.yaml
│       ├── prometheus.yaml
│       ├── rolebinding.yaml
│       ├── role.yaml
│       ├── route.yaml
│       ├── serviceaccount.yaml
│       └── service.yaml
│      
│
├── namespace.yaml  # It contains namespace manifest
│
│
├── nordmart  # It contains manifests for Nordmart Application
│
│   # Prometheus specific configuration
│   ├── catalog-prometheus-rule.yaml
│   ├── catalog-service-dashboard.yaml
│   ├── catalog-service-monitor.yaml
│
│   # Application specific configuration
│   ├── rolebinding.yaml
│   ├── role.yaml
│   ├── serviceaccount.yaml
│
│   # Normart Application Microservice
│   ├── cart.yaml
│   ├── catalog.yaml
│   ├── gateway.yaml
│   ├── inventory.yaml
│   ├── web.yaml
│   ├── review.yaml
│
│   # Database Manifests
│   ├── mongo.yaml
│   ├── mysql-secret.yaml
│   ├── mysql.yaml
│
│   # Nordmart Application Microservices
│   ├── route-gateway.yaml
│   └── route-web.yaml
│
│
│   # Documentation
├── README.md
│    
│   # Bash Scripts to replace the NAMESPACE placeholder in all manifests with user specified value
├── setup-vars.sh
│
│   # Storage Class manifest
└── storage-class.yaml

```

## Deployment Guidelines 

Follow the guidelines given below to deploy the application:

### `CODE SNIPPET`

Code snippet to replace `NAMESPACE` placeholder with `desired-value` in manifests.
```bash
sed -i 's/NAMESPACE/desired-value/g' *
```

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


3. Each participant will create a new namespace and will use that namespace in later manifests:

    ```bash
    oc apply -f namespace.yaml
    ```

    Each participant can check whether namespace is created or not using the command given below:
    ```bash
    oc get namespace
    ```

4. Deploying Monitoring Infrastructure Services

    4.1 Deploy the Prometheus Operator using the manifests given in `/infra/operator/` directory. Follow the instructions one by one:

    4.1.1. Create a service account:
    
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

    4.1.2 Create clusterrole:

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

    4.1.3. Create clusterolebinding:

    ```bash
    oc apply -f clusterrolebinding.yaml
    ```

    To check whether clusterolebinding is created or not:
    
    ```bash
    oc get clusterrolebinding | grep <clusterolebinding-name>
    ```
    
    To get clusterolebinding manifest:

    ```bash
    oc get clusterrolebinding <clusterolebinding-name> -oyaml
    ```

    ```
    MANIFEST
    ```

    4.1.4. Deploy deployment:

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

    4.1.5. Create a service:

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

    4.1.6. Create service monitor:

    ```bash
    oc apply -f servicemonitor.yaml -n <namespace>
    ```

    ```bash
    oc get servicemonitor <servicemonitor-name> -n <namespace>
    ```

    ```bash
    oc get servicemonitor <servicemonitor-name> -oyaml -n <namespace>
    ```

    4.2. Deploy prometheus using the manifests given in `/infra/prometheus/` directory. Follow the instructions one by one:
    
    4.2.1. Create serviceaccount:

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

    4.2.2 Create clusterrole:

    ```bash
    oc apply -f clusterrole.yaml
    ```

    To check whether clusterrole is created or not:
    
    ```bash
    oc get clusterrole | grep <clusterrole>
    ```

    To get clusterrole manifest:

    ```bash
    oc get clusterrole <clusterrole> -oyaml
    ```
    
    ```
    MANIFEST
    ```

    4.2.3. Create clusterolebinding:

    ```bash
    oc apply -f clusterrolebinding.yaml
    ```

    To check whether clusterolebinding is created or not:
    
    ```bash
    oc get clusterrolebinding | grep <clusterrolebinding-name>
    ```
    
    To get clusterrolebinding manifest:

    ```bash
    oc get clusterrolebinding <clusterrolebinding-name> -oyaml
    ```

    ```
    MANIFEST
    ```

    4.2.4. Deploy prometheus:

    ```bash
    oc apply -f prometheus.yaml -n <namespace>
    ```
    
    To check whether prometheus operator is deployed or not:
    ```bash
    oc get pod -n <namespace>
    ```
    
    To get the manifest:

    ```bash
    oc get pod <pod-name> -oyaml -n <namespace>
    ```

    4.2.5. Create prometheus service:

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

    4.2.5. Create prometheus route:

    ```bash
    oc apply -f route.yaml -n <namespace>
    ```

    ```bash
    oc get route -n <namespace> | grep <route-name>
    ```

    ```bash
    oc get route <route-name> -oyaml -n <namespace>
    ```

    4.2.6. Create secrets required by prometheus:

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


    4.3. Deploy grafana using the manifests given in `/infra/grafana/` directory. Follow the instructions one by one:

    4.3.1. Create serviceaccount:

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

    4.3.2 Create role:

    ```bash
    oc apply -f role.yaml -n <namespace>
    ```

    To check whether role is created or not:
    
    ```bash
    oc get role -n <namespace> | grep <role>
    ```

    To get role manifest:

    ```bash
    oc get role <role> -oyaml -n <namespace>
    ``` 
    
    ```
    MANIFEST
    ```

    4.3.3. Create rolebinding:

    ```bash
    oc apply -f rolebinding.yaml -n <namespace>
    ```

    To check whether rolebinding is created or not:
    
    ```bash
    oc get rolebinding -n <namespace>| grep <rolebinding-name>
    ```
    
    To get rolebinding manifest:

    ```bash
    oc get rolebinding <rolebinding-name> -oyaml -n <namespace>
    ```

    ```
    MANIFEST
    ```

    4.3.4. Create configmap:
    
    ```bash
    oc apply -f configmap.yaml -n <namespace>
    ```
    
    To check whether configmap is created or not:

    ```bash
    oc get configmap -n <namespace> | grep <configmap-name>
    ```

    To get configmap manifest:

    ```bash
    oc get configmap <configmap-name> -oyaml -n <namespace>
    ```

    4.3.5. Create grafana datasource config:

    ```bash
    oc apply -f datasources.yaml -n <namespace>
    ```

    ```bash
    oc get configmap -n <namespace> | grep <configmap-name>
    ```

    ```bash
    oc get configmap <configmap-name> -oyaml -n <namespace>
    ```

    4.3.6. Create grafana dashboard config:

    ```bash
    oc apply -f grafana-dashboard.yaml -n <namespace>
    ```

    ```bash
    oc get configmap -n <namespace> | grep <config-map> 
    ```

    ```bash
    oc get configmap <configmap-name> -oyaml -n <namespace>
    ```
    
    4.3.7. Create grafana secret:

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

    4.3.8. Create grafana deployment:

    ```bash
    oc apply -f deployment.yaml -n <namespace>
    ```

    To check whether grafana has been deployed or not:

    ```bash
    oc get pod -n <namespace>
    ```

    To get the deployment manifest
    ```bash
    oc get pod <pod-name> -oyaml -n <namespace>
    ```

    4.3.9. Create a service for grafana:
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
    
    4.3.10. Create route for grafana service to make it publically accessible:
    ```bash
    oc apply -f route.yaml -n <namespace>
    ```
    
    To check whether route is created or not
    ```bash
    oc get route -n <namespace>
    ```
    
    To get the route manifest:

    ```bash
    oc get route <route-name> -oyaml -n <namespace>
    ```

5. Deploying Nordmart Application Microservices:

    Details about Nordmart application can be found on this [link](https://playbook.stakater.com/content/workshop/nordmart-intro.html#introduction).

    5.1. Create a storage class:

    ```bash
    oc apply -f storage-class.yaml
    ```

    To check storage class is created

    ```bash
    oc get storageclass
    ```


    5.2. Apply the manifests given in `nordmart/` directory in the sequence given below:
        
    5.2.1 Create serviceaccount:
    
    ```bash
    oc apply -f serviceaccount.yaml -n <namespace>
    ```

    To check whether serviceaccount is created or not
    ```bash
    oc get serviceaccount -n <namespace>
    ```

    Once service account is created we will add a scc to that service account so that it can access node file system:
    
    ```bash
    oc adm policy add-scc-to-user -z sa anyuid -n <namespace>
    ```
    
    5.2.2. Create role:

    ```bash
    oc apply -f role.yaml -n <namespace>
    ``` 

    To check whether role is created or not:

    ```bash
    oc get role -n <namespace>
    ```

    To get role manifest
    ```bash
    oc get role <role-name> -oyaml -n <namespace>
    ```

    5.2.3. Create rolebinding:

    ```bash
    oc apply -f rolebinding.yaml -n <namespace>
    ```

    To check whether rolebinding is created or not:

    ```bash
    oc get rolebinding -n <namespace>
    ```

    5.2.4. Create mysql secret:
    
    ```bash
    oc apply -f mysql-secret.yaml
    ```

    5.2.5. Deploy mysql using the manifest given below:

    ```bash
    oc apply -f mysql.yaml -n <namespace>
    ```

    5.2.6. Deploy mongodb using the manifest given below:
    
    ```bash
    oc apply -f mongo.yaml -n <namepsace>
    ```

    5.2.7. Create catalog microservie monitoring manifests:

    ```bash
    oc apply -f catalog-prometheus-rule.yaml -n <namespace>
    ```

    ```bash
    oc apply -f catalog-service-dashboard.yaml -n <namespace>
    ```

    ```bash
    oc apply -f catalog-service-monitor.yaml -n <namespace>
    ```

    5.2.8. Deploy Nordmart microservice:
    
    ```bash
    oc apply -f inventory.yaml -n <namespace>
    oc apply -f cart.yaml -n <namespace>
    oc apply -f catalog.yaml -n <namespace>
    oc apply -f gateway.yaml -n <namespace>
    oc apply -f web.yaml -n <namespace>
    oc apply -f review.yaml -n <namespace>
    ```

    5.2.9. Create the routes for web and gateway service:

    ```bash
    oc apply -f route-gateway.yaml -n <namespace>
    oc apply -f web-gateway.yaml -n <namespace>
    ```

    5.2.10. Grafana can be accessed using the credentials given below:

    ```
    username: admin
    password: stakater
    ```