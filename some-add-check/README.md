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
- InstalL ansible
```
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible -y
```

- Copy key-pair in ansible_key

- Check with ping

```
chmod 700 ~/.ssh
chmod 600 ~/.ssh/ansible_key
ansible all -m ping -i /home/ubuntu/auto-kube/ansible/inventories/vbox.yaml --private-key=~/.ssh/ansible_key

sudo ssh -i ~/.ssh/ansible_key ubuntu@10.2.1.34
sudo ssh -i ~/.ssh/ansible_key ubuntu@10.2.1.25
sudo ssh -i ~/.ssh/ansible_key ubuntu@10.2.1.142
```

```
ansible-playbook -i inventories/vbox.yaml playbooks/ext.yaml

ansible-playbook -i inventories/vbox.yaml playbooks/init.yaml

ansible-playbook -i inventories/vbox.yaml playbooks/make-cluster.yaml

ansible-playbook -i inventories/vbox.yaml  playbooks/ext.yaml --private-key=~/.ssh/ansible_key

# If apt-get is not install latest version
pip install --upgrade ansible


sudo find / -name "config.toml" -type f
```
# 4 Check 
- Add {{ }} in hosts file : C:\Windows\System32\Drivers\etc\hosts
```

3.140.21.151 git.dn.tld
3.140.21.151 reg.dn.tld
3.140.21.151 ci.dn.tld 
```

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

# Check browser 
http://3.21.221.152:32256/
``````
# 5 Change code python {Know when use python}

```
# disable ssl 
git config --global http.sslVerify false
```
