#!/bin/bash

# check for required env variables
ERROR=0

if [ -z "$SSH_KEY" ]       ; then echo -e "\033[1;91mERROR:\033[0m SSH_KEY env variable is required"   && ERROR=1; fi
if [ -z "$KUBE_AUTH" ]     ; then echo -e "\033[1;91mERROR:\033[0m KUBE_AUTH env variable is required" && ERROR=1; fi
if [ -z "$KUBE_ZONE" ]     ; then echo -e "\033[1;91mERROR:\033[0m KUBE_ZONE env variable is required" && ERROR=1; fi
if [ -z "$KUBE_NAME" ]     ; then echo -e "\033[1;91mERROR:\033[0m KUBE_NAME env variable is required" && ERROR=1; fi

# check if credentials files exist
if [[ ! -f "/auth/$SSH_KEY"   ]] ; then echo -e "\033[1;91mERROR:\033[0m SSH public key file not found" && ERROR=1; fi
if [[ ! -f "/auth/$KUBE_AUTH" ]] ; then echo -e "\033[1;91mERROR:\033[0m Google service account json key file not found" && ERROR=1; fi

# stop script if errors detected
if [ $ERROR -eq 1 ]; then exit 1; fi

# authorize RSA key to connect to container
mkdir -p /root/.ssh && \
cat /auth/$SSH_KEY > /root/.ssh/authorized_keys && \
chmod 600 /root/.ssh/authorized_keys

export KUBE_PROJECT=$(cat /auth/$KUBE_AUTH | jq -r .project_id)
export KUBE_ACCOUNT=$(cat /auth/$KUBE_AUTH | jq -r .client_email)

if [ -z "$KUBE_PROJECT" ] || [ -z "$KUBE_ACCOUNT" ]; then 
	echo -e "\033[1;91mERROR:\033[0m invalid google service account json key"
	exit 1
fi

echo "Google Cloud Project: [ $KUBE_PROJECT ]"
echo "Google Cloud Account: [ $KUBE_ACCOUNT ]"
echo "Kubernetes cluster:   [ $KUBE_NAME ]"

# setup gcloud environment
gcloud config set project $KUBE_PROJECT
gcloud config set compute/zone $KUBE_ZONE

# establish connection to Kubernetes cluster for kubectl
gcloud auth activate-service-account $KUBE_ACCOUNT --key-file=/auth/$KUBE_AUTH && \
gcloud container clusters get-credentials $KUBE_NAME --zone $KUBE_ZONE --project $KUBE_PROJECT && \
printf "Testing connection...\n\n" && kubectl config view

# start SSH server
printf "\nAwaiting SSH connections...\n"
/usr/sbin/sshd -D
