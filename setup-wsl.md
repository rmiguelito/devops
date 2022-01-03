## Ansible
```bash
sudo apt install python3-pip
sudo pip install ansible jmespath jmespath-terminal --system
```
https://github.com/jmespath/jmespath.terminal

## Docker
```bash
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli
sudo service start docker
```

## PODMAN
```bash
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" |
sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

curl -L "https://download.opensuse.org/repositories/devel:/kubic:\
/libcontainers:/stable/xUbuntu_20.04/Release.key" | sudo apt-key add -

sudo apt-get update
sudo apt install -y podman

sudo chmod 4755 /usr/bin/newgidmap
sudo chmod 4755 /usr/bin/newuidmap

podman run --rm -it alpine
```

## DOCKER COMPOSE
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl
```
## Kind
```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
sudo -i
kind create cluster
kind delete cluster
```
## HELM
```bash
Download your desired version
Unpack it (tar -zxvf helm-v3.0.0-linux-amd64.tar.gz)
Find the helm binary in the unpacked directory, and move it to its desired destination (mv linux-amd64/helm /usr/local/bin/helm)
```

## Velero
```bash
wget https://github.com/vmware-tanzu/velero/releases/download/v1.7.1/velero-v1.7.1-linux-amd64.tar.gz
tar -xvf velero-v1.7.1-linux-amd64.tar.gz
chmod +x velero-v1.7.1-linux-amd64/velero
sudo mv velero-v1.7.1-linux-amd64/velero /usr/local/bin/
rm -rf velero-v1.7.1-linux-amd64
```

## IBM Cloud
```bash
wget https://download.clis.cloud.ibm.com/ibm-cloud-cli/2.3.0/IBM_Cloud_CLI_2.3.0_amd64.tar.gz
tar -xvf IBM_Cloud_CLI_2.3.0_amd64.tar.gz
cd Bluemix_CLI/
sudo bash install
add [[ -f /usr/local/ibmcloud/autocomplete/bash_autocomplete ]] && source /usr/local/ibmcloud/autocomplete/bash_autocomplete on /etc/profile
rm -rf IBM_Cloud_CLI_2.3.0_amd64.tar.gz
```

## AWS CLI
```bash
sudo apt install awscli
```

## EKS CTL
```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

## OC CLI
```bash
wget https://downloads-openshift-console.sao1-sibot-ocp4-dev-1-c-9bd168bd7799c8d70570dd790632a2cb-0000.sao01.containers.appdomain.cloud/amd64/linux/oc.tar
tar -xvf oc.tar
mv oc /usr/local/bin/
rm -rf oc.tar
```
## Terraform
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

#### TODO
Migrar instalações para Ansible
