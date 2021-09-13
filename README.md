# arbitrum
A place to spin up a single node small EKS cluster using terraform and  deploy sample app with haproxy-ingress.

##### REQUIREMENTS
* Terraform >=v1.0.0
* Should have an aws account and credentials setup in ~/.aws/crdentials

#### Getting started
first create a S3 bucket and a dynamo-db table to manage our remote terraform state file.
``` 
$ mv aws/remote_backend
$ terraform init
$ terrafor apply
```

Now we will spin up eks and vpc for our cluster
```
$ mv aws/
$ terraform init
$ terraform plan -var-file vpc.tfvars -var-file eks.tfvars
$ terraform apply -var-file vpc.tfvars -var-file eks.tfvars

```

Verify if you are able to connect with eks cluster and see the nodes
```
$ aws eks --region ap-south-1 update-kubeconfig --name dev-org
$ kubectl get nodes
```

Before creating pods get the private ip address of node from above command and update it here

Now we can apply kubernetes configurations

```
$ kubectl apply -f kubernetes/
```

Get the public ip of node and open up on browser.
* <public_ip_address>/foo
* <public_ip_address>/bar