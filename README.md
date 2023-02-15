# Cluster config & IaC

Getting a cluster going for a blog & the meander sequencer.

## K8S Cluster

### Preflight

#### Local

##### Create the cluster

Special config for the cluster is necessary if we want ingress to work.

```sh
kind create cluster --config=./kubernetes/kind/cluster.yaml
```

##### ingress

(Directions taken from [here][1], in case they stop working.)

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml && \
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s
```

##### kubernetes-secret-generator

Using `kubernetes-secret-generator` for... generating secrets:

```sh
helm repo add mittwald https://helm.mittwald.de
helm upgrade --install kubernetes-secret-generator mittwald/kubernetes-secret-generator
```

TODO: how do I incorporate this such that it doesn't need to be a manual step before `apply`?

#### Prod (on digital ocean)

##### Create the cluster & the db

```sh
cd terraform/production
terraform init # if it's your first time
terraform apply
```

##### Setup cluster dependencies

```sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml

# export a base64 encoded token as env var DO_TOKEN
export DO_TOKEN=$(echo -n "<token_string>" | base64)

curl --silent https://raw.githubusercontent.com/digitalocean/do-operator/v0.1.5/releases/do-operator-v0.1.5.yaml | \
  yq e '(.data | select(. | has("access-token"))).access-token|=strenv(DO_TOKEN)' | \
    kubectl apply -f -
```

### `apply`'ing

```sh
kubectl apply -k ./kubernetes/local
```

## Shortcuts that you (John) will forget or have already forgotten

### Get name of pod

```sh
kubectl get pods -n ghost -l <label_key>=<label_value> -o jsonpath'{.items..metadata.name}'
```

### Get a secret

```sh
kubectl get secret -n ghost <secret_name> -o jsonpath='{.data.<key>}' | base64 -D
```

### Connect to msyql

```sh
kubectl run -it --namespace ghost --rm \
  --image=$(kubectl get deployments -n ghost --field-selector metadata.name=ghost-mysql -o jsonpath='{.items..spec.template.spec.containers..image}') \
  --restart=Never \
    mysql-client -- \
      mysql -h ghost-mysql -p$(kubectl get secret -n ghost mysql-root-password -o jsonpath='{.data.password}' | base64 -D)
```

### Shell in cluster

```sh
kubectl run my-shell --rm -i --tty --image ubuntu -- bash
```

[1]: https://kind.sigs.k8s.io/docs/user/ingress/