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