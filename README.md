# infrastructure-challenge
Attached with this challenge, you will find a simple Python - Flask Web App, which reads the current RAM and CPU usage and a React frontend which shows the statistics in the browser.

# How to run?
The app is setup in a pretty standard way, just like most Python-React Apps.

## Python Backend
> Python Version used: 3.11.3 (installed with pyenv)
In the api directory, do the following.
1. `pip install -r requirements.txt`
2. `python app.py`
3. Visit [this](http://localhost:8080/stats)

## React Frontend
> Node version used: v16.20.1 (installed with nvm)
In the sys-stats directory, do the following.
1. `npm install`
2. `npm start`
> Tip: on `src/app.js` you can find the fetch to the backend.

Kindly create a different branch, do not use `main`.

# Task 1 - Dockerize the Application
The first task is to dockerise this application - as part of this task you will have to get the application to work with Docker. You can expose the frontend using NGINX or HaProxy.

The React container should also perform npm build every time it is built. 
Create 3 separate containers. 1 for the backend, 2nd for the proxy and 3rd for the react frontend.

It is expected that you create another small document/walkthrough or readme which helps us understand your thinking process behind all of the decisions you made.

You will be evaluated based on the:
* best practices
* ease of use
* quality of the documentation provided with the code

## Building Images

First, I chose to use an automated process to build and push the images to ECR. For this, I used a GitHub Actions pipeline that builds the images whenever a new PR is opened in this repository. When the merge to `main` is done, it should build and push the images to the `python-api` and `node-frontend` ECR repositories. The names of these repositories can be easily changed in the pipeline matrix.

To grant GitHub the necessary permissions for pushing images, we'll use GitHub OpenID. For this purpose, I've built a module that will grant the required permissions for this repository. After deploying this module, you'll need to add the role ARN from the pipeline into `role-to-assume`.

Anyway, if it's not possible to use GitHub OpenID, I've created a script located in the root of this project with the name `docker_build_push.sh` to facilitate the build and push of Docker images.
Before using the script, you'll need to install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) the necessary permissions where the push will be performed.

Example of usage for the script:

```shell
./docker_build_push.sh repository=flask-api aws_region=eu-west-1 dockerfile_path=./api/
```

| Name | Description | Required |
|------|-------------|:--------:|
| repository | Repository ECR name | yes |
| aws_region | AWS region where the script will work | yes |
| dockerfile_path | Path where the Dockerfile is located | yes |
| image_tag | Tag for the image; if no tag is specified, it will try to use tags from 0.1 to 10.9 | no |

## Terraform

After the process of building and pushing the images to your ECR repository, we will deploy them to [ECS](https://github.com/Aily-Labs/infrastructure-challenge/blob/a0d095686fa76e9bd1662ae01294bad42a344385/terraform/main.tf#L20).

For this, I've added 3 new modules that can be found in `./terraform/modules`. The ECR module is responsible for creating the repositories in your desired AWS ECR account, and the ECS module will deploy the images in your account.

On the ECS module, you can configure the infrastructure without deploying the containers by simply ignoring the variables `frontend_docker_image` and `flask_api_docker_image`. This is because you will need to create your repositories in ECR first before deploying the images to ECS. Alternatively, you can temporarily remove this module from `./terraform/main.tf` while creating the repositories on ECR and then add it back.

You will also need to provide three variables from ECS module: `vpc_id`, `subnets_id`, and `ecr_repositories_arn`. You can find more information about these variables [here](https://github.com/Aily-Labs/infrastructure-challenge/blob/a0d095686fa76e9bd1662ae01294bad42a344385/terraform/modules/ecs/README.md).

With that said, you will need to [configure your AWS credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) with permissions to deploy this on your AWS account. You don't need to worry about the provider version since it's already defined [here](https://github.com/Aily-Labs/infrastructure-challenge/blob/a0d095686fa76e9bd1662ae01294bad42a344385/terraform/provider.tf#L5).

# Task 2 - Deploy on AWS with terraform
It's important to remember here that the application is already containerize, maybe
you could deploy it to services which take an advantage of that fact. (example, AWS
EC2 or ECS?)
The React App should be accessible on a public URL.
Use the best practices for exposing the cloud VM to the internet, block access to
unused ports, add a static IP (elastic IP for AWS), create proper IAM users and
configure the app exactly how you would in production.

Hints:
* It is acceptable the use of other tools like Ansible for some tasks.
* Terraform code is not expected to fully work, the purpose of this exercise is to validate terraform skills and AWS Service knowledge.
* You can assume some bootstraping of the account is already in place, like VPC.

You will be evaluated based on the:
* terraform code
* best practices
* quality of the documentation provided with the code

# Task 3 - Get it to work with Kubernetes
Next step is completely separate from step 2. 
Go back to the application you built-in Stage 1 and get it to work with Kubernetes.
Separate out the two containers into separate pods, communicate between the two containers, add a load balancer (or equivalent), expose the final App over port 80 to the final user (and any other tertiary tasks you might need to do)

Describe the process to:
1. Boostrap the cluster
2. Create the Deployment, Service, RBAC, etc. to make the app work
3. (extra) How to manage the continuous deployment with FluxCD / ArgoCD

Hints:
* You can use tools like `minikube` / `kind` to have the cluster working locally

You will be evaluated based on the:
* best practices
* quality of the documentation provided

# Task 4 - AWS Tooling
Next step is completely separate from last tasks.
The exercise here is to create a CLI tool to fetch available EC2 AMI on AWS.

The expected input parameters for the CLI are:
1. **Regions** (list of strings, required) (example: us-east-1 us-west-1 eu-central-1 eu-west-1)
2. **Architecture** (string, required) (example: amd64)
3. **OS** (string, required) (example: ubuntu)
4. **Date created** (string, optional) (example: 01.06.2023)

You must use: python or goland

You will be evaluated based on the:
* Coding skills
* Input Validation
* Implementation of Help for usage of the CLI
* Error Handling

# Summary
This documentation is supposed to be very high-level, you will be evaluated on the basis of the low level decisions you make while implementing it and your thought process behind them. If you have any questions at all feel free to reach out and ask for help. Please package your code up in a Github repo and share the link.

Best of luck!
