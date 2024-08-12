# MNIST Simple Computer Vision Demo (from azinonos tutorial)

Code for Beginner Deep Learning Tutorial on the MNIST Digits Classification Neural Network in Python using Keras

Commented jupyter notebook ready to use for simple classifier demo purpose

INSPIRED BY:

https://github.com/azinonos/MNIST_DL_Tutorial

# Deploy Computer Vision Demo on a Kubernetes cluster

## Deploy the application

Deploy the application using the following command on your Kubernetes cluster 

    curl https://raw.githubusercontent.com/fsa-france/computer-vision-demo/main/deploy_cvdemo.sh | bash
    
## Access the application

To access the application, use the URL provided after deploying the application

## Delete the application

To remove the application from your kubernetes cluster use the following command :

    kubectl delete -f https://raw.githubusercontent.com/fsa-france/computer-vision-demo/main/cvdemo.yaml
    
