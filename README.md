**Maintainers**
* alexsedova
* [Dzhuneyt](https://github.com/Dzhuneyt)

# Terraform + AWS + Docker Swarm setup

Here is the basic setup to run up docker swarm cluster in AWS using the Terraform.
[Terraform](https://www.terraform.io) is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. Using Terraform helps to create the infrastructure you can change, and trace safely and efficiently. A small swarm cluster will be created during startup. One swarm manager + two swarm workers. In the  *app-instances.tf* you will find the configuration. The swarm is initiated during provisioning. All other swarm agents (workers) will connect to the manager by a token, generated during the swarm initialisation. The trick is we should do it automatically, but we don't know the token before the initialisation. To send the token to the agents, I copy it to a file on the swarm manager and do "scp" to the master host from the agent's machines.

## Installation 
How to install terraform you can find [here](https://www.terraform.io/intro/getting-started/install.html). Or you can using a Docker image to keep your environment clear. For example, [this one](https://hub.docker.com/r/amontaigu/terraform/).

## Preparations
### AWS account 
If you don't have account, you may get a free AWS account. In the setup will be used free t2.micro instances. 
#### SSH keys
Before to start, create ssh keys. Terraform will create key-pair in AWS, based on these keys. See [how to create ssh keys](https://confluence.atlassian.com/bitbucketserver/creating-ssh-keys-776639788.html)
Create a pem file with private ssh key you generated. Terraform will need to the pem file to connect to instances for provisioning.
#### Update the project file with new information
There are three file need your credentials for successing run up. First of all, update *key-pair.tf* set there a path to the public ssh key, generated earlier. In *variables.tf* update your AWS account information. In *app-instances.tf* update connection block for each resources, set there the path to ssh private key.    

## How to use
After all configuration files are ready, you can do check if there are no mistakes.
```
terraform plan
```
This command will show either syntax errors or list of resources will be created. After you can run:
```
terraform apply
```
This command will build and run all resources in the *.tf files. If you run this command many times, Terraform will destroy previous instances before creating new ones. 
That is it. Now you have fully functioned docker swarm cluster in AWS.

If you want to terminate instances and destroy the configuration you may call:
```
terraform destroy
```
