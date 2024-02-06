#!/bin/bash

install_docker() {
    sudo apt update -y 
    sudo apt install ca-certificates curl awscli -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    local CURRENT_USER=$(echo $USER)
    sudo usermod -aG docker $CURRENT_USER
    newgrp docker
}

install_minikube() { 
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    minikube version
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    kubectl version -o yaml
    minikube start --driver=docker
    minikube status
    minikube addons enable ingress
    eval $(minikube docker-env) 
}

INSTALL=""
CURRENT_DATE=$(date)

for arg in "$@"
do
    case $arg in  
        install=*)
        INSTALL="${arg#*=}"
        shift
        ;;
        *)

        ;;
    esac
done

INSTALL=$(echo "${INSTALL}" | tr '[:upper:]' '[:lower:]')
INSTALL_VALID_ACTIONS=("docker" "minikube")

if [[ ! " ${INSTALL_VALID_ACTIONS[*]} " =~ " ${INSTALL} " ]]; then
    echo -e "\n----> Please specify one of the following actions: ${valid_versions[*]}"
    echo -e "* ${CURRENT_DATE} - ERROR: Invalid action specified: ${ACTION}\n"
    exit 1
fi

case ${INSTALL} in
    docker)
        install_docker
        ;;
    minikube)
        install_minikube
        ;;
esac
