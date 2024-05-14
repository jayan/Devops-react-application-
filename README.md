
# React deployment

Project Title: React Deployment Capstone Project
 
Application:-
clone the below repositry and deploy the application (Run     application in port 80)

Repo URL:- https://github.com/sriram-R-krishnan/devops-build


AWS:
Launch t2.micro instance and deploy the create application.
Configure SG as below:
Whoever has the ip address can access the application
Login to server can should be made only from your ip address


#write a terraform script to Launch t2.micro instance and deploy the create application. Configure SG as below: Whoever has the ip address can access the application
Login to server can should be made only from your ip address.

create in terraform file 
```bash
  nano instance
```


![photo1715596808](https://github.com/jayan/private/assets/83051900/7f355a68-e2d6-4369-a573-7663c64f2239)
And write a script

```bash
  provider "aws" {
  region = "ap-south-1"
}

# Create a security group allowing inbound SSH access from your IP address only
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins instance"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.44.15.122/32"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launching EC2 instance named "jenkins" with Ubuntu image, t2.micro instance type, and your specified key pair
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"
  key_name      = "webserver"  # Specify your existing key pair name here
  
  tags = {
    Name = "jenkins"
  }

  security_groups = [aws_security_group.jenkins_sg.name]
}

```

And intialize, plan, and apply
```bash
  terraform init
  terraform plan
  terraform apply
```
![photo1715596808 (3)](https://github.com/jayan/private/assets/83051900/5579358f-1637-46b2-a8b8-3a429ca0b72b)

![photo1715596808 (1)](https://github.com/jayan/private/assets/83051900/d794814f-3ae6-4e8a-8d9b-69ae3a20b79d)

![photo1715596808 (2)](https://github.com/jayan/private/assets/83051900/a27a2371-c042-48ef-9dae-7c9b10231aed)

![photo1715596808 (4)](https://github.com/jayan/private/assets/83051900/1df525e8-8431-4d21-9509-8b80a50a31b3)



(or) 
Create Security Group:
Go to the AWS Management Console and navigate to the EC2 service.

In the left navigation pane, under "Network & Security", select "Security Groups".
Click on the "Create security group" button.
![photo1715597391 (6)](https://github.com/jayan/final-project/assets/83051900/63a9306b-9cdc-4385-a8c8-8acac70fd89e)
Provide a name, description, and configure the inbound rule first inbound rule port no should be 80 and make it access any one.
![photo1715597391 (7)](https://github.com/jayan/final-project/assets/83051900/7560c3b5-7eb7-4d41-be2c-c9697ef82df1)

And second inbound rule is to choose port 22 and login acces through our ip address 
enter our ip address/32.
![photo1715597391 (7)](https://github.com/jayan/final-project/assets/83051900/1395e341-c5d8-4e4c-821c-a40f76f87ded)

Click on the "Create security group" button to create the security group.
![photo1715597391 (9)](https://github.com/jayan/final-project/assets/83051900/8e3bb43b-fbe8-4dfb-9ea9-937ce62dcd5f)

And go to  EC2 dashboard, click on the "Launch Instance" button.
Choose an Amazon Machine Image (AMI), instance type, configure instance details, add storage configure security groups (select the one you just created), add tags, and configure any additional options as needed.
![photo1715597391 (10)](https://github.com/jayan/final-project/assets/83051900/9292d124-f5fc-4114-b9ef-1dcfbd44dce1)

Review your configuration and click on the "Launch" button.
Select an existing key pair or create a new one.
Finally, click on the "Launch Instances" button to launch your instance.

login into the created server 

## git clone 

To clone the these use 
```bash
  git clone https://github.com/sriram-R-krishnan/devops-build
```
Docker:

Dockerize the application by creating a Dockerfile.

Create a docker-compose file to use the above image.

# TO dockerzing the the application 
install a docker on  machine by using docker.sh file that i uploaded in repo located in installation directory.
And copy the all the files from the cloned reposity to a directory called devops-Capstone

```bash
  cp -r devops-build/build /root/devops-capstone
```
create docker file 
```bash
  nano dockerfile
```
heres the dockerfile content 
```bash
  # Use the official Ubuntu base image
  FROM nginx:latest
  COPY . /usr/share/nginx/html/
```
And create docker compose file to use the image 
```bash
  nano docker-compose.yaml
```
here is the docker compose-file content 
```bash
version: '3'
services:
  app:
    image: ${IMAGE_NAME} # here i utilized the environmental varible to get the image 
    ports:
      - "80:80"  
```


Bash Scripting:
Write 2 scripts

build.sh for building docker images.

deploy.sh for deploying the image to server.

# write a bash  scripting 
create a build.sh file to build an image 
```bash
  nano build.sh
```
here is the scripting file of bash.sh
```bash
#!/bin/bash

# Incremented count for image name
IMAGE_COUNT=$(($(docker images | grep -c "^react") + 1))

# Build and tag the Docker image without using cache
docker build --no-cache -t "react:${IMAGE_COUNT}" .

# Echo the image name
echo "Built Docker image: react:${IMAGE_COUNT}"
```
create a deploy.sh file  for deployment 

```bash
  nano deploy.sh
```

heres the deploy.sh file contnet 
```bash
 #!/bin/bash

# Docker Hub username
DOCKER_USERNAME="cjayanth"

# Check the argument passed
if [[ "$1" == "devchanged" ]]; then
    echo "Tagging and pushing image to dev repository..."
    IMAGE_COUNT="$2"  # Use the count passed as an argument
    docker tag "react:${IMAGE_COUNT}" "${DOCKER_USERNAME}/dev:Latest${IMAGE_COUNT}"
    docker push "${DOCKER_USERNAME}/dev:Latest${IMAGE_COUNT}"
    export IMAGE_NAME="react:${IMAGE_COUNT}"  # Export before running docker-compose
    docker compose up -d
elif [[ "$1" == "devmergedmaster" ]]; then
    echo "Tagging and pushing image to prod repository..."
    IMAGE_COUNT="$2"  # Use the count passed as an argument
    docker tag "react:${IMAGE_COUNT}" "${DOCKER_USERNAME}/prod:Latest${IMAGE_COUNT}"
    docker push "${DOCKER_USERNAME}/prod:Latest${IMAGE_COUNT}"
    docker push "${DOCKER_USERNAME}/dev:Latest${IMAGE_COUNT}"
    export IMAGE_NAME="react:${IMAGE_COUNT}"  # here Exported the image before running docker-compose
    docker compose up -d
else
    echo "Invalid argument. Please provide either 'devchanged' or 'devmergedmaster'."
    exit 1
fi
  
```

Version Control:
Push the code to github to dev branch (use dockerignore & gitignore file).
Note: Use only CLI for related git commands.

# create a repositry on git hub default should be master 

clone the repositry using 
```bash
  git clone https://github.com/jayan/final-project.git
```
copy all files and directories from devops-capstone to cloned repo
And use git commands to push the code to the git hub 
now  create a branch called dev  and chekout to dev
```bash
  git checkout -b dev
```
create .gitignore and .dockerignore file  in case want ignore particular files to prevent the push  to central repo
and use gitcommands to push all the files directory into a central  dev repo
```bash
  git add .
  git commit -m "commiting first time
  git origin push master
```







Docker hub:
Create 2 repos "dev" and "prod" to push images.
"Prod" repo must be private and "dev" repo can be public.

#Docker hub:
Create 2 repos "dev" and "prod" to push images.
"Prod" repo must be private and "dev" repo can be public.


Jenkins:
Install and configure jenkins build step as per needs to build, push & deploy the application.
Connect jenkins to the github repo with auto build trigger from both dev & master branch.
 If code pushed to dev branch, docker image must build and pushed to dev repo in docker hub.
If dev merged to master, then docker image must be pushed to prod repo in docker hub.

#jenkins installation 
install jenkins on machine by using jenkins.sh file that was uploaded in my repo located in installation directory run the jenkins.sh file directly by using 
```bash
  bash jenkins.sh
```
```bash
  systemctl enable jenkins
  systemctl restart jenkins
```
Now try to access the jenkins and login into the jenkins 

#configure the required plugins  according to the requirement

create a jenkinsfile  on machine  and define a workflow and push it to the github.
```bash
  pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Branch Name: ${env.BRANCH_NAME}"
                    git branch: "${env.BRANCH_NAME}", url: 'https://github.com/jayan/capstone-devops.git'
                }
            }
        }
        stage('Build and Push (Conditional)') {
            steps {
                script {
                    echo "Branch Name: ${env.BRANCH_NAME}"
                    if (env.BRANCH_NAME == 'dev') {
                        sh 'chmod +x build.sh'
                        def buildOutput = sh(script: './build.sh', returnStdout: true).trim()
                        def imageCount = buildOutput.tokenize(':').last()  // Extract the image count
                        echo "Image count: ${imageCount}"
                        sh 'chmod +x deploy.sh'
                        sh "./deploy.sh devchanged ${imageCount}" // Pass only the image count
                    } else if (env.BRANCH_NAME == 'master') {
                        def mergeCommit = sh(script: "git log --merges --first-parent -1 --pretty=format:\"%H\"", returnStdout: true).trim()
                        def isMerged = sh(script: "git branch --contains ${mergeCommit}", returnStdout: true).trim()
                        if (isMerged.contains('* dev')) {
                            echo "Dev branch has been merged to main, executing build and deploy..."
                            echo "checking merges"
                            sh 'git checkout dev' // Switch to dev branch
                            sh 'git pull origin dev' // Pull latest changes from dev branch
                            sh 'chmod +x build.sh'
                            def buildOutput = sh(script: './build.sh', returnStdout: true).trim()
                            def imageCount = buildOutput.tokenize(':').last()  // Extract the image count
                            echo "Image count: ${imageCount}"
                            sh 'chmod +x deploy.sh'
                            sh "./deploy.sh devmergedmain ${imageCount}" // Pass only the image count
                        } else {
                            echo "Dev branch has not been merged to main, skipping build and deploy."
                        }
                    } else {
                        echo "Skipping build and deploy for branch: ${env.BRANCH_NAME}"
                    }
                }
            }
        }
    }
}
```
so that we can create a multibranch pipeline to  Connect jenkins to the github repo with auto build trigger from both dev & master branch and If code pushed to dev branch, docker image must build and pushed to dev repo in docker hub.
If dev merged to master, then docker image must be pushed to prod repo in docker hub.
Go to jenkins dashboard and creat new job select multibranch pipeline.
Branch source is git and enter git url  and click on add and select filter by name (with wildcards). 
```bash
  master* dev*
```

 In scan multibranch pipeline triggers select scan by webhook and enter 
```bash
  cloud
```
 Go to git hub repo in settings choose webhook option and create webhook 
 
 Playload URL*
 ```bash
  http://3.109.56.73:8080/multibranch-webhook-trigger/invoke?token=cloud
```

select push event and create 
after created the webhook. go to jenkins and  click on save and apply and it will connect jenkins to github repo with auto trigger from both dev and master branch If code pushed to dev branch, docker image must build and pushed to dev repo in docker hub 
here you can see below image  the dev branch  get started building and deploy it into the docker hub into dev branch



if dev merged to master than the image will get pushed  to prod in docker hub 




Monitoring:
setup a monitoring system to check the health status of the application (open-source)
sending notification sending the notifications only if application goes down is highly appreciable.


#To monitoring my application 


Go to the docker file do some changes in it.
these is my previous dockerfile 
```bash
  # Use the official Ubuntu base image
  FROM nginx:latest
  COPY . /usr/share/nginx/html/
```
after changing
```bash
# Use the official Ubuntu base image
FROM nginx:latest
COPY . /usr/share/nginx/html/
COPY nginx/ /etc/nginx/
# Expose port 80 for your application
EXPOSE 80
# Expose port 8080 for your metrics
EXPOSE 8081
```

Install Nginx Prometheus Exporter¶
 fetch all the available metrics for now. We'll use the Nginx prometheus exporter to do that. It's a Golang application that compiles to a single binary without external dependencies, which is very easy to install.

First of all, let's create a folder for the exporter and switch directory.

```bash
mkdir /opt/nginx-exporter
cd /opt/nginx-exporter
```
create a dedicated user for each application that you want to run. Let's call it an nginx-exporter user and a group.

```bash
sudo useradd --system --no-create-home --shell /bin/false nginx-exporter
```

From the releases pages on GitHub, let's find the latest version and copy the link to the appropriate archive. In my case, it's a standard amd64 platform.

We can use curl to download the exporter on the Ubuntu machine.

```bash
curl -L https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.11.0/nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz -o nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz
```
Extract the prometheus exporter from the archive.

```bash
tar -zxf nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz
```

You can also remove it to save some space.

```bash
rm nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz
```
Let's make sure that we downloaded the correct binary by checking the version of the exporter.

```bash
./nginx-prometheus-exporter --version
```
It's optional; let's update the ownership on the exporter folder.

```bash
chown -R nginx-exporter:nginx-exporter /opt/nginx-exporter
```
```bash
vim /etc/systemd/system/nginx-exporter.service
```
Make sure you update the scrape-uri to the one you used in Nginx to expose basic metrics. Also, update the Linux user and the group to match yours in case you used different names.
```bash
nginx-exporter.service

[Unit]
Description=Nginx Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=0

[Service]
User=nginx-exporter
Group=nginx-exporter
Type=simple
Restart=on-failure
RestartSec=5s

ExecStart=/opt/nginx-exporter/nginx-prometheus-exporter \
    -nginx.scrape-uri=http://3.7.66.132:8081/status

[Install]
WantedBy=multi-user.target
```
Enable the service to automatically start the daemon on Linux restart.

```bash
systemctl enable nginx-exporter
```
Then start the nginx prometheus exporter.

```bash
systemctl start nginx-exporter
```
Check the status of the service.

```bash
systemctl status nginx-exporter
```

And install a  Node Exporter  used for monitoring and collecting metrics from Linux system 

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.0/node_exporter-1.8.0.linux-amd64.tar.gz
```
```bash
tar -zxf node_exporter-1.8.0.linux-amd64.tar.gz
rm -rf node_exporter-1.8.0.linux-amd64.tar.gz
mv node_exporter-1.8.0.linux-amd64 /etc/node_exporter
```
create node_exporter.service file 
```bash
nano /etc/systemd/system/node_exporter.service
```
enter the info in it 
```bash
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=always
[Install]
WantedBy=multi-user.target
```
```bash
systemctl enable node_exporter
```
Then start the nginx prometheus exporter.

```bash
systemctl start node_exporter
```
Check the status of the service.

```bash
systemctl status node_exporter
```



#setup a monitoring system 
using terraform script to create an instance called prometheus
these is my terraform script to create an instance 
 ```bash
  terraform script 
```
Install Prometheus¶
Now let's quickly install the latest version of prometheus on the same host.

Create a dedicated Linux user for Prometehus to scrap matric from the deployed application.

Let's check the latest version of Prometheus from the download page.

You can use the curl or wget command to download Prometheus.

 ```bash
curl -L https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz -o prometheus-2.41.0.linux-amd64.tar.gz
 ```
Then, we need to extract all Prometheus files from the archive.

 ```bash
tar -xvf prometheus-2.41.0.linux-amd64.tar.gz
 ```
```bash
mv prometheus-2.41.0.linux-amd64 /etc/prometheus
 ```

create prometheus.service
 
nano /etc/systemd/system/prometheus.service
 ```
And wite 
```bash
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
ExecStart=/etc/prometheus/prometheus --config.file=/etc/prometheus/prometheus.yml
Restart=always
[Install]
WantedBy=multi-user.target
 ```
run 
```bash
systemctl demon-reload
systemctl enable prometheus
systemctl start prometheus
```


```bash
nano /etc/prometheus/prometheus.yml

```

add  data in it 
```bash
scrape_configs:
  - job_name: "nginx-prometheus-exporter"
    static_configs:
      - targets: ["3.7.66.132:9113"]
  - job_name: "nginx-fluentd"
    static_configs:
      - targets: ["3.7.66.132:9100"]

```
```bash
systemctl restart prometheus
```

Now you can go to http://<ip>:9090/ to check if the prometheus is working.

Under the targets section, you should have a single nginx-prometheus-exporter target.

Now install grafana in the prometheus instance only.  Grafana is used for visualizing and monitoring metrics and logs through interactive and customizable dashboards.
go to the following document to install grafana https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/

After installation completes
To automatically start the Grafana after reboot, enable the service.

```bash
systemctl enable grafana-server
```
Then start the Grafana.
```bash
systemctl start grafana-server
```
To check the status of Grafana, run the following command

```bash
systemctl status grafana-server 
```

Now you can access Grafana on port http://<ip>:3000. The username is admin, and the password is admin as well.

First of all, let's add our Prometheus as a datasource.
For the URL, use http://localhost:9090 and click save and test.
Let's create a two  dashboards 
one is for application monitoring call it as nginx and another is for my machine monitoring call it as node exporter
Create a new Panel.
For the metrics use nginx_connections_active.
For the legend {{ instance }}.
Title: Active Connections.
I'm going to fill out the rest of the panels using the metrics that we retried from the status page. You can find this dashboard in my github repository.


