# Terraform

## Projects
- Provision EC2 based HTTP Servers with Load Balancer
- Provision AWS and Azure Kubernetes Clusters (Azure DevOps Pipelines)

## Steps
- Step 01 - Creating and Initializing First Terraform Project
- Step 02 - Create AWS IAM User Access Key and Secret
- Step 03 - Configure Terraform Environment Variables for AWS Access Keys
- Step 04 - Creating AWS S3 Buckets with Terraform
- Step 05 - Playing with Terraform State - Desired, Known and Actual
- Step 06 - Playing with Terraform Console
- Step 07 - Creating AWS IAM User with Terraform
- Step 08 - Updating AWS IAM User Name with Terraform
- Step 09 - Understanding Terraform tfstate files in depth
- Step 10 - gitignore Terraform tfstate files
- Step 11 - Refactoring Terraform files - Variables, Main and Outputs
- Step 12 - Creating Terraform Project for Multiple IAM Users
- Step 13 - Playing with Terraform Commands - fmt, show and console
- Step 14 - Recovering from Errors with Terraform
- Step 15 - Understanding Variables in Terraform
- Step 16 - Creating Terraform Project for Understanding List and Map
- Step 17 - Adding Elements - Problem with Terraform Lists
- Step 18 - Creating Terraform Project for Learning Terraform Maps 
- Step 19 - Quick Review of Terraform FAQ
- Step 20 - Understanding Creation of EC2 Instances in AWS Console
- Step 21 - Creating New Terraform Project for AWS EC2 Instances
- Step 22 - Creating New EC2 Key Pair and Setting Up
- Step 23 - Adding AWS EC2 Configuration to Terraform Configuration
- Step 24 - Installing Http Server on EC2 with Terraform - Part 1
- Step 25 - Installing Http Server on EC2 with Terraform - Part 2
- Step 26 - Remove hardcoding of Default VPC with AWS Default VPC
- Step 27 - Remove hardcoding of subnets with Data Providers
- Step 28 - Remove hardcoding of AMI with Data Providers
- Step 29 - Playing with Terraform Graph and Destroy EC2 Instances
- Step 30 - Creating New Terraform Project for AWS EC2 with Load Balancers
- Step 31 - Create Security Group and Classic Load Balancer in Terraform
- Step 32 - Review and Destroy AWS EC2 with Load Balancers
- Step 33 - Creating Terraform Project for Storing Remote State in S3 
- Step 34 - Create Remote Backend Project for Creating S3 Buckets
- Step 35 - Update User Project to use AWS S3 Remote Backend
- Step 36 - Creating multiple environments using Terraform Workspaces
- Step 37 - Creating multiple environments using Terraform Modules



## Commands Executed

```
brew install terraform
terraform --version
terraform version
terraform init
export AWS_ACCESS_KEY_ID=*******
export AWS_SECRET_ACCESS_KEY=*********
terraform plan
terraform console
terraform apply -refresh=false
terraform plan -out iam.tfplan
terraform apply "iam.tfplan"
terraform apply -target=aws_iam_user.my_iam_user
terraform destroy
terraform validate
terraform fmt
terraform show
export TF_VAR_iam_user_name_prefix = FROM_ENV_VARIABLE_IAM_PREFIX
export TF_VAR_iam_user_name_prefix=FROM_ENV_VARIABLE_IAM_PREFIX
terraform plan -refresh=false -var="iam_user_name_prefix=VALUE_FROM_COMMAND_LINE"
terraform apply -target=aws_default_vpc.default
terraform apply -target=data.aws_subnet_ids.default_subnets
terraform apply -target=data.aws_ami_ids.aws_linux_2_latest_ids
terraform apply -target=data.aws_ami.aws_linux_2_latest
terraform workspace show
terraform workspace new prod-env
terraform workspace select default
terraform workspace list
terraform workspace select prod-env
```


## plan Command - will give brief sumamry of what will happen if we apply changes 

## apply command - will actually execute command.

## States in Terraform are :

        Desired - is the state that we specify in .tf file

        KNOWN - is the state that Terraform has stored in .tfstate file at time of creating resources.

        ACTUAL - is the current state of resources that terraform will look for whenever we apply changes, and compare it with the KNOWN state.

        Terraform create two state files while executing any changes--

            .tfstate  -- current state
            .tfstatebackup -- previous step prior to the executing of current state


## Tags in Terraform --

    1.provider tag = it defines the cloud provider that we want to use

        ```
            syntax :

                    provide "aws" {
                        region="us-east-1"
                        version=" ~> 3.0"
                    }
        ```


    2.resource tag = it defines that we want to create resource in our cloud.
                   Anything we want to create in our cloud using terraform, use "resource" tag

                   It takes two argument --

                        "name_of_resource" = eg aws_s3_bucket
                        "terraform_internal_name_for_that_resource"


        ```
            syntax :

                    resource "aws_s3_bucket" "my_s3_bucket"{
                        bucket="my-s3-bucket-001"
                        versioning {
                            enabled=true
                        }
                    }

                    resource "aws_iam_user" "my_iam_user"{
                        name="my_iam_user_001"
                    }

        ```

## creating multiple resource in aws using Terraform


            ```
                Syntax :

                        provider "aws" {
                            region="us-east-1"
                            access_key=""
                            secret_key=""
                        }

                        resource "aws_iam_user" "my_aws_iam_users" {
                            count=4
                            name="my_aws_users_${count.index}"
                        }
            ```


## adding variable to the terraform.

        
        1. using default value -- If we don't specify the default value in variable 
                                   section then terraform will prompt for the value when we execute command "terraform apply".
            ```
                syntax:

                        variable "<varibale_name>" {
                            type=string  #any,bool,number,map,tuple,set,object,list
                            default="value_for_variable"
                        }

                        resourse "aws_s3_bucket" "my_aws_s3_bucket" {
                            count = 3
                            bucket = "${var.variable_name}_${count.index}"
                        }


        2. can also EXPORT or SET as variable--

            ```
            $SET TF_VAR_<VARIABLE_NAME>=ENV_VAR_MY_AWS_IAM_USER

            ```

        3. using "variables.tfvars"  file --

            ```
                VARIBALE_NAME="value"

            ```

        4. using command line --

            ```
                syntax :

                        terraform apply -refresh=false -var="<variable_name>=<value>"
            ```

        5. Precedance -- command line >> .tfvars.file >> env_variable >> default value set


## terraform list--

     1. can create list in terraform for variables

        [Terrform Collection](https://www.terraform.io/docs/language/functions/list.html)


            ```
                syntax :


                    variable "<list_variable>" {
                        default=["value1","value2","value3","value4"]
                    }

                    resourse "aws_iam_user" "my_aws_iam_user" {
                        count = length(var.names)
                        name = var.names[count.index]
                    }

            ```
    2.  Terraform list -- addition of new item in list will modify the existing terraform plan dramatically as elements in list are stored using number as index and while executing "terraform plan/apply" command will check that elements at index are changed then it will change accordingly.

        However, we can convert list to set using  ```toset(var.list)``` and use ```for_each```
        function to iterate through sets



            ```

                syntax :

                    variable "names" {
                        default=["value1","value2","value3","value4"]
                    }

                    resource "aws_iam_user" "my_aws_iam_user" {
                        for_each = toset(var.names)
                        name=each.value
                    }
            ```


## Terraform Map :
    
        1. key- value pair in terraform

            ```
                syntax :

                        variable "<variable_name>" {
                            default= {
                                key1 : "value1",
                                key2 : "value2",
                                key3: "value3",
                                key4: "value4" 
                            }
                        }


                        variable "names" {
                            default = {
                                abhi: "India",
                                naruto: "Village hidden in leaf",
                                obito: "Village hidden in rain"

                            }
                        }

                        resource "aws_iam_user" "my_aws_iam_user" {
                            for_each = var.<variable_name>
                            name = each.key
                            tags = {
                                country: each.value
                            }
                        }]

            ```

        2. key:"value" pairs within value i.e. dictionary within dictionary


            ```
                syntax :

                        variabel "names" {
                            default = {
                                abhi: {country:"india"},
                                naruto : {country:"leaf village"}
                            }
                        }




                        resource "aws_iam_user" "my_aws_iam_user" {
                                    #using map
                                    for_each = var.users
                                    name= each.key
                                    tags = {
                                    country:each.value.country
                            }



# Creating EC2 instance in AWS using terraform


## Creating security group --

    1. Security group specifies the rules that should be imposed on EC2 or virtual server
       to retsrict access,

    2. Rule for incoming traffic (access from valid ip address on valid port)

    3. Rule for outgoing traffic


        ```
            syntax :


                resource "aws_security_group" "http_server_sg" {
                    name = "http_server_sg"

                    #to which vpc id , this security group should be part of
                    vpc_id = "<vpc_id>" 


                    #igress rule .. rule for incoming traffic
                    #for  http server/access, can have multiple ingress rules

                    ingress {
                        from_port = 80
                        to_port = 80
                        protocol = "tcp"
                        cidr_blocks = ["0.0.0.0/0"]   # specifies range of IP addrr.
                    }


                    #egress rule.. rule for outgoing traffic 

                    engree {
                        from_port = 0
                        to_port = 0
                        protocol = -1
                        cider_blocks = ["0.0.0.0/0"]

                    }

                    tags = {
                        name = "http_server_sg"
                    }

                }

        ``` 


    4. Create an key-value pair for EC2 to install http server or other configuration


    5. Creating EC2 resource configuration in terrafrome

        ```
            syntax :

                    resource "aws_instance" "<instance_name>" {

                        #ami image name i.e. which os should be used
                        ami = "<ami_name>"

                        #instance type for this EC2 instance .. hardware basically
                        instance_type = "<instance_type>"

                        #key that should be associated with this EC2 instance
                        key_name = "<key_name_created_in_step_4>"

                        #security groups to be attached
                        vpc_security_group_ids = [aws_security_group.<name_of_security_group>.id]

                        #subnet to which this EC2 should be attached
                        subnet_id=<subnet_id>

                    }

        ```


## Connection to the EC2 instance

    To connect to the EC2 instance we need, below details 

        type = which access we want .. ssh
        host = host to which we want to connect if want to connect itself use self
        user = which user should be used to connect
        private_key = private key for that particular instance to whoch we want to connect

    
    ```
        Syntax :
        
            variable "variable_path_for_pem_file" {
                default = "path_to_pem_file"
            }

            provider "aws" {
                region = "<region_name>"
                access_key = "<access_key>"
                secret_key = "<secret_key>"
            }

            resource "aws_security_group" "http_server" {
                name = "security_group"

                vpc_id = "<vpc_id>"

                ingress {
                    from_port = "<from_port>"
                    to_port = "<to_port>"
                    protocol = "<protocol>"
                    cidr_blocks = ["0.0.0.0/0"]
                }

                
                enress {
                    from_port = "<from_port>"
                    to_port = "<to_port>"
                    protocol = "<protocol>"
                    cidr_blocks = ["0.0.0.0/0"]
                }

                tags ={
                    name = "https-security_group"
                }
            }

            resource "aws_instance" "http-server-ec2" {

                ami = "<ami>"

                vpc_security_group_ids = "<vpc_security_group_ids>"

                subnet_id = "<subnet_id>"

                instance_type = "<instance_type>"

                key_name = "<key_name>"


                connection {
                    type = "<ssh>"
                    user = "<user>"
                    private_key = file(var.variable_path_for_pem_file)
                    host = <host/self.public_ip>
                }
            }

        ```

    2. after connection we need to eecute specific commmands.lets say we want to install we server



        ```
            syntax :

                provisioner "remote-exec"{
                    inline = [
                        "sudo yum install httpd -y",
                        "sudo start httpd service",
                        "echo Message -- public dns -- ${self.public_dns} | sudo tee /var/www/html/index/html"
                    ]
                }

        ```

## Fetching defualt VPC from aws and use it into terraform .tf file

        ```
            syntax :

                    resource "aws_default_vpc" "default_vpc" {

                    }

                    resource "aws_security_group" "http_server_sg" {
                        name = "<name>"
                        vpc_id = aws_default_vpc.default_vpc.id
                    }

        ```

        
## Use of data provider tag in Terraform :-

        we can access fields in data provider by usig "data.<data_provider_name>.<internal_name>"


        ```
            syntax :


                    data "aws_subnet_ids" "default_subnet_ids" {
                        vpc_id = aws_default_vpc.default.id
                    }


                    data "aws_ami" "aws_ami_linux_2" {
                        most_recent = true 
                        owner = "amazon"

                        filter {
                            name = "name"
                            values = ["amzn2-ami-hvm-*"]
                        }
                    }


                    resource "aws_instance" "ec2_instance" {
                        
                        ami = data.aws_ami.aws_ami_linux_2.id
                        instance_type = "<instance_type>"
                        vpc_security_group_ids = "<vpc_security_group_ids>"
                        key_name = "<key_name>"
                        subnet_id = tolist(data.aws_subnet_ids.default_subnet_ids.ids)[0]


                    }