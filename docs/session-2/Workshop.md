## Prometheus Operator Installation

### Setup the repository locally
1. Clone the stakater monitoring workshop.
```bash
git clone https://github.com/stakater-lab/stakater-monitoring-workshop.git
```

2. Checkout to workshop branch
```bash
git checkout azure-openshift-workshop
```

3. Update namespace names in manifest files
    1. Goto `application` directory.
    2. Change the namespace name to a unique name
    3. Run the `setup-vars.sh` script
```bash
cd application
NAMESPACE=participant-3 # CHANGE ME
# Setup vars for individual namespaces
./setup-vars.sh $NAMESPACE
```

### Create Namespace

Command:
```bash
# Create Namespace
oc apply -f namespace.yaml
```

### Create Storage Class

Command:
```bash
# Create storage class 
oc apply -f storage-class.yaml
```

### Create Prometheus Operator

Prometheus Operator installation Comes with 
- clusterrole.yaml
- clusterrolebinding.yaml
- deployment.yaml
- service.yaml
- serviceaccount.yaml
- servicemonitor.yaml

Command:
```bash
## Deploy Prometheus Operator
oc apply -f infra/operator/.
```

Verify that Prometheus Operator Pod is running finr.

Command:
```bash
oc get pods -n openshift-monitoring
```

