# Cluster config & IaC

Getting a cluster going for a blog & the meander sequencer.

## K8S Cluster

### Preflight

Using `kubernetes-secret-generator` for... generating secrets:

```sh
helm repo add mittwald https://helm.mittwald.de
helm upgrade --install kubernetes-secret-generator mittwald/kubernetes-secret-generator
```

TODO: how do I incorporate this such that it doesn't need to be a manual step before `apply`?

### `apply`'ing

```sh
kubectl apply -f base/
```

## Shortcuts that you (John) will forget or have already forgotten

### Get name of pod

```sh
kubectl get pods -l <label_key>=<label_value> -o jsonpath'{.items..metadata.name}'
```

### Get a secret

```sh
kubectl get secret <secret_name> -o jsonpath='{.data.<key>}' | base64 -D
```

### Connect to msyql

kubectl run -it --rm \
  --image=mysql:8-debian \
  --restart=Never \
    mysql-client -- \
      mysql -h mysql -p$(kubectl get secret mysql-root-password -o jsonpath='{.data.password}' | base64 -D)
