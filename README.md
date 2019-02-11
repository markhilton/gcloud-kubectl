# gcloud-kubectl

**gcloud-kubectl** is a [Docker](https://www.docker.com/) image to authorize [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command line tool, to connect to a [Kubernetes](https://kubernetes.io/) cluster running on [Google Cloud](https://cloud.google.com/).

**gcloud-kubectl** container exposes [SSH](https://www.ssh.com/ssh/) port to make it possible to execute `kubectl` commands remotely.

## Variables (required)

-   `SSH_KEY` Public RSA key file authorized to connect to container via SSH port
-   `KUBE_AUTH` [Google service account](https://cloud.google.com/iam/docs/understanding-service-accounts) json key file with privileges to manage Kubernetes
-   `KUBE_NAME` Kubernetes cluster name to connect to
-   `KUBE_ZONE` Kubernetes cluster location zone

## Example use

Start container by mounting the volume from local file system containing public RSA key and Google service account json key (/config in this example) into /auth directory inside the container.

```
docker run --rm \
    -v /config:/auth \
    -e SSH_KEY=/auth/id_rsa.pub \
    -e KUBE_AUTH=/auth/gcloud-auth.json \
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
            - SSH_KEY=/auth/id_rsa.pub
            - KUBE_AUTH=/auth/gcloud-auth.json
            - KUBE_NAME=kubernetes
            - KUBE_ZONE=us-central1-f
```
