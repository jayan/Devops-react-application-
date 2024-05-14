
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
    cidr_blocks = ["103.44.15.122/32"]  # Restrict SSH to your IP address
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow inbound access on port 80 from anyone
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

![photo1715672479](https://github.com/jayan/final-project/assets/83051900/f27f6bf3-31a4-4d73-b445-2bb57e9218aa)
![photo1715672479 (1)](https://github.com/jayan/final-project/assets/83051900/b0be0575-f148-45e3-b51e-7300a9104493)
![photo1715672479 (2)](https://github.com/jayan/final-project/assets/83051900/35111499-cc44-428c-a62e-f5a58dbb4141)
![photo1715672479 (3)](https://github.com/jayan/final-project/assets/83051900/de3dedcc-640e-4ebf-9494-e5d39b864d84)


clone the repositry using 
```bash
  git clone https://github.com/jayan/final-project.git
```

![photo1715672660](https://github.com/jayan/final-project/assets/83051900/f45281b3-741b-4f1c-8ddd-3b37fdf75cf2)

copy all files and directories from devops-capstone to cloned repo
And use git commands to push the code to the git hub 
now  create a branch called dev  and chekout to dev
```bash
  git checkout -b dev
```
![photo1715672788](https://github.com/jayan/final-project/assets/83051900/02cd6262-088d-4bec-a10e-152ef5d1ce51)
![photo1715672788 (1)](https://github.com/jayan/final-project/assets/83051900/177e7a57-6246-4dd4-b567-40dbbdbc498b)
![photo1715672788 (2)](https://github.com/jayan/final-project/assets/83051900/900aece4-7360-460b-b001-5e0f7615dbf2)

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

#create 2 repos in docker hub 
go to the dockerhub account and click on create repositry 

Create 2 repos "dev" and "prod" to push images.

"Prod" repo must be private and "dev" repo can be public.
![photo1715673119](https://github.com/jayan/final-project/assets/83051900/8c0a6bfe-8f7b-47b8-9230-1744d2dff0a3)


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

![photo1715673267](https://github.com/jayan/final-project/assets/83051900/cdbff7b9-e962-4069-b71b-18e2d1490d4c)
![photo1715673287](https://github.com/jayan/final-project/assets/83051900/f6af2140-71c3-4617-baa3-850a11d6a103)
![photo1715673287 (1)](https://github.com/jayan/final-project/assets/83051900/23dd821e-8102-4271-ab10-1a79bcaf14dc)
![photo1715673287 (1)](https://github.com/jayan/final-project/assets/83051900/af92e943-7254-4cd6-9146-7c22bf17cf56)



#install the  plugins  according to the requirement

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
now we can create a multibranch pipeline to  Connect jenkins to the github repo with auto build trigger from both dev & master branch 

If code pushed to dev branch, docker image must build and pushed to dev repo in docker hub.

If dev merged to master, then docker image must be pushed to prod repo in docker hub.

Go to jenkins dashboard and creat new job select multibranch pipeline.
![photo1715673658](https://github.com/jayan/final-project/assets/83051900/56485964-d7d3-4119-ad97-7d1b6d072210)
![photo1715673658 (1)](https://github.com/jayan/final-project/assets/83051900/5eb2a10b-2553-411c-a83e-4e925da068d8)
![photo1715673658 (2)](https://github.com/jayan/final-project/assets/83051900/27a442dd-15b0-4274-80e3-62b3d6e161bc)
![photo1715673658 (9)](https://github.com/jayan/final-project/assets/83051900/3495c31f-7021-4633-84e0-77b2e1f33df5)

Branch source is git and enter git url  and click on add and select filter by name (with wildcards). 
![photo1715673658 (3)](https://github.com/jayan/final-project/assets/83051900/878293e2-584e-441a-9223-57be3a029b35)
![photo1715673658 (4)](https://github.com/jayan/final-project/assets/83051900/3c701e21-078d-4e43-8f09-3b4e13e300de)
photo1715673658 (5)

```bash
  master* dev*
```

![photo1715673658 (6)](https://github.com/jayan/final-project/assets/83051900/a0e39b49-4fbb-4b76-ac04-4c8d54f70121)

And enter the path of the  jenkinsfile from  your github repositry path and select scanwebhook to triiger the build evrytime when ever the change will happaned in github repo 
 In scan multibranch pipeline triggers select scan by webhook and enter 
```bash
  cloud
```
![photo1715673658 (8)](https://github.com/jayan/final-project/assets/83051900/47a05de2-2289-40ab-b398-1906b5f817dc)


create a webhook in a GitHub repository, go to the repository's settings, navigate to the "Webhooks" section, click "Add webhook," provide the jenkinsurl and configure other settings as needed, then click "Add webhook" to save.

![photo1715674221](https://github.com/jayan/final-project/assets/83051900/3962016e-b328-452a-9012-a8122c344a83)

![photo1715674221 (1)](https://github.com/jayan/final-project/assets/83051900/fa890790-1dff-4f15-9673-a177aa22538e)

 
 Playload URL*
 ```bash
  http://3.109.56.73:8080/multibranch-webhook-trigger/invoke?token=cloud
```
![photo1715674221 (1)](https://github.com/jayan/final-project/assets/83051900/ded79055-06a6-4287-9a1e-0e5b00f5b4df)

![photo1715674221 (3)](https://github.com/jayan/final-project/assets/83051900/79714999-ef3f-45a3-bb0a-afb9f5430bb2)



after created the webhook. go to jenkins and  click on save and apply

![photo1715674628](https://github.com/jayan/final-project/assets/83051900/d8bafe00-cdee-4dc2-a9ec-c48c0738412f)


now it will  auto trigger from both dev and master branch If code pushed to dev branch, docker image must build and pushed to dev repo in docker hub 
here you can see below image  the dev branch  get started building and deploy it into the docker hub into dev branch

![photo1715675091](https://github.com/jayan/final-project/assets/83051900/2a6699ee-2fe3-40a4-ab78-3c751eccfc0b)
here is the console output 
![photo1715675122 (1)](https://github.com/jayan/final-project/assets/83051900/dc1e19ed-fb38-4404-a42b-fefbf7a160c5)

![photo1715675122](https://github.com/jayan/final-project/assets/83051900/01fb949d-baae-485f-abcb-d2965d9fd4e7)
now go to the docker hub and check weather image was uploaded or not 
![photo1715675190 (1)](https://github.com/jayan/final-project/assets/83051900/54c77b9b-1645-433a-b7d3-7cd9dc5a629b)
here is the image that was uploaded. every time it get start building  the  image will be created with the name of react each time it build image the name will be change it starts increase the count  like react1 react2 react3.  and the tag name should also change Latest1 Latest2
![photo1715675190](https://github.com/jayan/final-project/assets/83051900/5eae483c-c4a7-4be2-82bc-153ca00e503b)


if dev merged to master than the image will get pushed  to prod in docker hub 
![photo1715676945](https://github.com/jayan/final-project/assets/83051900/122a0615-5547-42eb-af8b-430d1389c1f6)
![photo1715676945 (1)](https://github.com/jayan/final-project/assets/83051900/4dc40d46-a801-49fb-8a03-72233d9130cb)
here if dev merged to master than it will start  trigger automatically and make it run build.sh and and deploy.sh and d will finally push it into the docker hub pro repo 
![photo1715676787](https://github.com/jayan/final-project/assets/83051900/1060fe9d-8b7c-4d33-b233-f5245139c092)
![photo1715676458 (1)](https://github.com/jayan/final-project/assets/83051900/057bf8c8-1c97-49d7-8ee3-f25df2927b87)
![photo1715676458 (2)](https://github.com/jayan/final-project/assets/83051900/f9bcb237-5af7-40fc-b567-26bc3bfa99f7)
latest7 was a tag name and image name will be react7
![photo1715676586](https://github.com/jayan/final-project/assets/83051900/6d0eb4e9-c86d-46c7-aa3b-51c5c98de4ae)



Monitoring:
setup a monitoring system to check the health status of the application (open-source)
 sending the notifications only if application goes down is highly appreciable.


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
and upload it  into the github repo
#Install Nginx Prometheus Exporter
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
nano /etc/systemd/system/nginx-exporter.service
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

![photo1715677567](https://github.com/jayan/final-project/assets/83051900/25f779d3-fb98-43b1-892c-914eaee3b133)
access it by using <ip>:9113

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

![photo1715677519](https://github.com/jayan/final-project/assets/83051900/374049bb-b3a2-44df-bb3f-ffd98548cf82)
access it by using <ip>:9100


#setup a monitoring system 
using terraform script to create an instance called prometheus
these is my terraform script to create an instance 
 ```bash
  terraform script 
```
connect to the prometheus instance 

#Install Prometheus¶
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
![photo1715677801](https://github.com/jayan/final-project/assets/83051900/de128436-67c2-44c8-8227-8bc149d9a3b1)



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
![photo1715677861](https://github.com/jayan/final-project/assets/83051900/cb6f2ad5-f9ab-4830-aeb6-ce46e5b74e1d)

First of all, let's add our Prometheus as a datasource.
For the URL, use http://localhost:9090 and click save and test.
![photo1715678044](https://github.com/jayan/final-project/assets/83051900/f38cf6d5-9522-4bff-ae19-e688b82e68ee)

![photo1715678044 (1)](https://github.com/jayan/final-project/assets/83051900/46da17cd-9cfd-4f71-8b80-f5bd9cd8d1a4)
![photo1715678044 (2)](https://github.com/jayan/final-project/assets/83051900/3070169d-207f-4664-9f8f-a8ad0e893b1a)
add prometheus server url 
![photo1715678261](https://github.com/jayan/final-project/assets/83051900/79174895-0109-489f-8b0f-a863bd9e540a)

![photo1715678044 (4)](https://github.com/jayan/final-project/assets/83051900/57c478c4-9233-4fb4-bced-43ae3c64a295)

Let's create a two  dashboards 
one is for application monitoring call it as nginx and another is for my machine monitoring call it as node exporter
![photo1715678370](https://github.com/jayan/final-project/assets/83051900/2b704ec6-9f2e-499c-ad62-3df45ef0c929)


I'm going to fill out the panels using the metrics that we retried from the status page. You can find this dashboard in my github repository.

these my nginx dashbord that monitors my application
![photo1715678699](https://github.com/jayan/final-project/assets/83051900/53f27058-a8f4-4c3c-9972-9b59bb4673bf)

these will monitor weather my application was up and running  if in these dashbord nginx_up = 0 it means the application is down and if it shows nginx_up = 1 it means application is up and running 
![photo1715678699 (1)](https://github.com/jayan/final-project/assets/83051900/15765b1b-034b-42a6-9c20-28013df60e63)

these is my  node dashboard that monitor my instance 
![photo1715678699 (2)](https://github.com/jayan/final-project/assets/83051900/66b134d6-c44e-4424-b263-870ba82efeed)

#To send notification if my application goes down 

go to the alert rules click on create alertrule and follow the below image

![photo1715679395](https://github.com/jayan/final-project/assets/83051900/dddc2dac-dfe3-4096-975c-14d979c948c0)

![photo1715679395 (1)](https://github.com/jayan/final-project/assets/83051900/9a24dac2-61d2-44db-a289-d8dd1c39f45e)

here i written a condition that the given  posql query if the  value below 1 it will get a alert 
![photo1715679395 (2)](https://github.com/jayan/final-project/assets/83051900/fd3db020-a765-4dfc-9a59-ee66da943a7c)
![photo1715679395 (3)](https://github.com/jayan/final-project/assets/83051900/0bee192e-e5f0-4800-b626-e325c282a117)

And click on save it


![photo1715679631](https://github.com/jayan/final-project/assets/83051900/442590fb-4a5f-4870-882c-8c606e911313)

After these go to the contact poit and click on add contact point. and configure the email id and save it 
![photo1715679793](https://github.com/jayan/final-project/assets/83051900/3e4bbbb4-c09c-4bc3-953e-e88ab3bb1b60)


![photo1715679793 (1)](https://github.com/jayan/final-project/assets/83051900/3da8ee7c-559f-49f2-82e4-56bcf33c3cf2)


And go to the /etc/grafana/grafana.ini and configure these 
```bash
[smtp]
enabled = true
host = your_smtp_server_address
port = 587
user = your_smtp_username
password = your_smtp_password
```
and navigate to the contact point which you have create and click on start test notification to check weather its workking or not if you get mail it means its working

![photo1715680083](https://github.com/jayan/final-project/assets/83051900/0f4fa298-4d90-4432-a4ad-7a582f6eb76e)

![photo1715680083 (1)](https://github.com/jayan/final-project/assets/83051900/0c7d90c3-cd2e-4e34-bd76-93046f32fb8b)


go to the notification policies and create new policy to make a  connetion with alret rule and  contact point 


now here you see my application was up and running 

![photo1715680485](https://github.com/jayan/final-project/assets/83051900/223a5a4d-8656-4d82-ae4b-875d4accfb77)

if i go to my deployementent machine and stop the application i will get a nofification that my server was down 

![photo1715680485 (1)](https://github.com/jayan/final-project/assets/83051900/b09bb862-5f4f-4fc6-9ff3-019ea74eef67)


![photo1715680485 (2)](https://github.com/jayan/final-project/assets/83051900/4d2cb01c-7d0a-4315-9bf8-7fe9f8f871ce)

![photo1715680485 (3)](https://github.com/jayan/final-project/assets/83051900/ab0ff993-aca7-48af-a084-92db74b95266)


![photo1715680485 (4)](https://github.com/jayan/final-project/assets/83051900/6a81957b-b3fb-4b6f-a4ef-4ac637b9e6ac)

here i get the notification that my server was down

![photo1715680485 (5)](https://github.com/jayan/final-project/assets/83051900/c7527221-545a-45d5-a052-b77b82a3d7a1)

![photo1715680485 (6)](https://github.com/jayan/final-project/assets/83051900/7c01fca6-3e50-4eb8-b0ed-34679d790aa9)




#my deployed site URL

link:- http://3.7.66.132/

![photo1715680898](https://github.com/jayan/final-project/assets/83051900/204155d6-1c08-4558-b178-a64c824524ac)

![photo1715680898 (1)](https://github.com/jayan/final-project/assets/83051900/33accfb2-8b7d-4c06-b0a5-137514fe0364)




















