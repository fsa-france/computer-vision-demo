# MNIST Simple Computer Vision Demo (from azinonos tutorial)

Code for Beginner Deep Learning Tutorial on the MNIST Digits Classification Neural Network in Python using Keras

Commented jupyter notebook ready to use for simple classifier demo purpose

INSPIRED BY:

https://github.com/azinonos/MNIST_DL_Tutorial

# Deploy Computer Vision Demo on a Kubernetes cluster

## Deploy the application

Deploy the application using the following command on your Kubernetes cluster :

kubectl apply -f https://raw.githubusercontent.com/fsa-france/computer-vision-demo/main/cvdemo.yaml

## Access the application

To access the application, you need to retrieve the token in the container logs.

Access the logs through the following command :

    kubectl logs -n cvdemo cvdemo-app| grep token
  

>`[root@master-1 ~]# kubectl logs -n cvdemo cvdemo-app| grep token  
>[I 2024-08-08 08:26:30.606 ServerApp] http://cvdemo-app:8888/tree?token=`**fd102504fdaa74e2ec2b4c27a83872b9a778ad9ed9e10043**`
>[I 2024-08-08 08:26:30.606 ServerApp]     http://127.0.0.1:8888/tree?token=`**fd102504fdaa74e2ec2b4c27a83872b9a778ad9ed9e10043**`
>        http://cvdemo-app:8888/tree?token=`**fd102504fdaa74e2ec2b4c27a83872b9a778ad9ed9e10043**`
>        http://127.0.0.1:8888/tree?token=`**fd102504fdaa74e2ec2b4c27a83872b9a778ad9ed9e10043**`

Get TCP port used by the LoadBalancer service :

    kubectl get svc -n cvdemo cvdemo-svc -o json| jq -r '.spec.ports[0].nodePort'

>`[root@master-1 ~]# kubectl get svc -n cvdemo cvdemo-svc -o json| jq -r '.spec.ports[0].nodePort'`  
>**`32153`**
   

Access the following URL with previous info from token and service :

http://<any_ip_of_your_nodes>:**32153**/tree?token=**fd102504fdaa74e2ec2b4c27a83872b9a778ad9ed9e10043**

