# The goal of this project is to learn the fundamental concepts of Kubernetes (deployment, network, persistence, secrets and inter-service communication) through a real but simple application.


## In this project, we will learn:

Distributed application architecture (frontend and backend)

Application deployment using deployment

Data persistence management with PersistentVolume and PersistentVolumeClaim

Securing sensitive information with Secrets

Setting up network communication with services

Exposing applications to the outside world with Nodeport


## Simplified application architecture :
<img width="672" height="672" alt="diagkub" src="https://github.com/user-attachments/assets/4f8e1411-b351-44c8-965a-18a25e8808c7" />


## Sensitive information (MySQL username, password, database name, root password) is stored in a Kubernetes secret (mysql-secret).

This secret is:

used by MySQL to initialize the database

used by WordPress to connect to MySQL

## Since Kubernetes Pods are ephemeral, the project uses persistent volumes to store data:

MySQL: database data storage (/var/lib/mysql)

WordPress: file storage (themes, plugins, uploads) (/var/www/html)

The mechanism relies on:

PersistentVolume (represents the disk)

PersistentVolumeClaim (storage request from the application)

## MySQL Service (ClusterIP):

Accessible only within the cluster

Secure, not exposed to the internet

WordPress Service (NodePort):

Exposed to the outside world

Accessible via port 30001

Kubernetes provides an internal DNS server, allowing WordPress to connect to MySQL using the service name mysql-svc.

# Project Deployment

Clone the repository:

git clone https://github.com/watchiMass/mini-projet-kubernetes.git

cd mini-projet-kubernetes/

Deploy all manifests:

kubectl apply -f . 

ou 

cd mysql

kubectl apply -f . 

cd wordpress

kubectl apply -f . 

Check resource status:

kubectl get pods

kubectl get svc

Accessing WordPress

Retrieve the IP address of a Kubernetes node:

kubectl get nodes -o wide

Then access WordPress via a browser:

http://NODE_IP:30001
