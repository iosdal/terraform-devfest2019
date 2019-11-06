## Description
 
The project is a simple demo for Devfest 2019

The app was a simple node.js webapp using Mongodb as backend.

Webapp is dockerized using a Dockerfile and deployed on a AKS Azure Cluster deployed Terraform.

The CI part use Travis, Github for source repository and Docker Hub for the image registry.

Both the webapp and Mongodb are deployed on the AKS by the travis CI.

For achieving the target I use also helm chart for Mongodb and Nginx.

A scaling part is done using Kubernetes Horizontal Pod Autoscale.

Optionally the monitoring solution use both helm chart for Prometheus+Grafana.


## Terraform

Before starting clone the entire project.

This part require Terraform https://www.terraform.io/ (tested with v0.12.5) an account on Terraform for remote state https://app.terraform.io , an Azure account and a service principal as described here:

https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html

Once obtained put it in azure.auto.tfvars under cloned root directory:

`client_id= "XXX"`

`client_secret = "XXX"`

`tenant_id = "XXX"`

`subscription_id = "XXX"`

and deploy using local terraform plan and apply.

5 resources will be created:

- azurerm_resource_group : resource group containing all the deployment
- azurerm_kubernetes_cluster : selfexplaining

At the end terraform will output

`kube_config`

Save it, this variable is required in the next step by Travis CI.


## Travis CI

This part require to connect your Travis server with the repo where you clone the entire project.

I use

https://travis-ci.org

connected to my repo in GitHub.
You must set these variables to point to your Docker Hub in Travis before run CI:

`DOCKER_REPO`

`DOCKER_USERNAME`

`DOCKER_PASSWORD`

If you don't want to rebuild the app these variables are not required and you have to comment the `before_script` step in `.travis.yml` file.

Save `kube_config` Terraform output to a private repo, create a GITHUB_ACCESS_TOKEN and set as variable in Travis. Change the line accordling:

`- curl -o config https://$GITHUB_ACCESS_TOKEN@raw.githubusercontent.com/iosdal/privaterepo/master/.kube/config`

pointing to your private repo containing the kubernetes credentials.

Travis CI steps explained:

- install: install kubectl,helm binaries and copy Kubernetes config file;
- before_script: build the app using `Dockerfile` and push to Docker registry;
- script: all the required components are deployed on the Kubernetes cluster:
    - helm installing on the cluster;
    - mongodb with a PVC to persist data;
    - deployment of the app itself in `deployment`;
    - deployment of nginx ingress controller;
    - deployment of the monitoring parts using prometheus+grafana;
    - output of the nginx public ip address and grafana password.

After running the CI and waiting few minutes for having all the resources running, obtain the public ip of the app using:

`kubectl get service -l app=nginx-ingress --namespace demo`

Point the browser to this public IP.

For acceding grafana use 

`export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=grafana,release=grafana" -o jsonpath="{.items[0].metadata.name}")`

and

`kubectl --namespace monitoring port-forward $POD_NAME 3000`

with password obtained in CI or from:

`kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

## Various

Being only a demo, a lot of parts are not production ready:

- mongodb require username and password and maybe as a service using Atlas (kubernetes is not a perfet fit for prodution db);
- https with certificate
- secure helm
- implement mongodb backup
- some variables passing...

## License

MIT

