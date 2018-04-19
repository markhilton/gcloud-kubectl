# gcloud-kubectl

gcloud-kubectl is a Docker container that establishes connection to Kubernetes cluster running on Google Cloud end exposes SSH port to make it possible to execute `kubectl` remote commands.

## Variables (required)

`SSH_KEY` 
public RSA key file authorized to connect to container via SSH port

`KUBE_AUTH`
Google service account json key file with privileges to manage Kubernetes

`KUBE_NAME`
Kubernetes cluster name to connect to

`KUBE_ZONE`
Kubernetes cluster location zone

## Example use

Start container by mounting the volume from local file system containing RSA key and Google service account json key (/config in this example) into /auth directory inside the container.

```
docker run --rm \
    -v /config:/auth \
    -e SSH_KEY=id_rsa.pub \
    -e KUBE_AUTH=gcloud-auth.json \
    -e KUBE_NAME=kubernetes \
    -e KUBE_ZONE=us-central1-f \
    -ti crunchgeek/gcloud-kubectl
```

### docker-compose.yml

```
version: "3"

services:
    gcloud_sdk:
        image: crunchgeek/gcloud-kubectl
        volumes:
            - /config/:/auth
        environment:
            - SSH_KEY=id_rsa.pub
            - KUBE_AUTH=gcloud-auth.json
            - KUBE_NAME=kubernetes
            - KUBE_ZONE=us-central1-f
```
