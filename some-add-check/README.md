# 1 Set up enviroment : VPC 
- Public Subnet : 3 subnet
- IGW
- Routable : 0.0.0.0 to IGW
- Atttach IGW with VPC

# 2 Setup EC2 - Keypair - Security Group {Update by Terraform} + Elastic IP
- Creat EC2 
- SG : 
    + Maybe all traffic first

    + All traffic from worker node
- Elastic IP
# 2.1 Setup Route 53

# 3 Run code And Fix
- Copy key-pair in ansible_key

- Check with ping

```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/ansible_key
ansible all -m ping -i /home/ubuntu/ansible --private-key=~/.ssh/ansible_key

sudo ssh -i ~/.ssh/ansible_key ubuntu@ip_server1
```


# 4 Check 

```
# ip public of mext:10443,11443,12443

# ip public of cp0
# - Check in LoadBalancer : Take port
# - Get in CP0

kubectl get namespace
kubectl get all -n argocd
kubectl get all -n argocd
# ip:{port}

```
```
# Argo CD
https://3.85.116.205:30589/
# Kubernetes 
https://3.85.116.205:30764/

``````
# 5 Change code python {Know when use python}

```
# disable ssl 
git config --global http.sslVerify false
```
