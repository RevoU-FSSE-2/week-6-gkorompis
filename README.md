# Simple Server Application
Getting started to backend development and cloud computing by serving a simple node js application on docker container in a AWS cloud enviroment.
<br>

<img width="916" alt="hello-world-lg" src="https://github.com/RevoU-FSSE-2/week-6-gkorompis/assets/52250424/f1a5cc5d-ec12-454b-8ca3-c84c10abc642">

<br>

## Introduction
Docker is a powerful tool that offers several benefits for modern application development and deployment. One of its key advantages is the ability to isolate applications in containers, ensuring consistent dependencies and configurations across different environments. This portability allows developers to deploy applications seamlessly on various platforms, from local development machines to production servers. Additionally, Docker's containerization approach enhances resource efficiency by sharing the host OS kernel among containers, resulting in faster startup times and reduced memory usage. With versioned images, Docker enables version control, making it easy to track changes, rollback to previous states, and maintain consistency across development, staging, and production environments. Furthermore, Docker facilitates scalability by allowing effortless replication and management of multiple container instances, ensuring high availability and performance during peak demand. Combined with container orchestration tools like Kubernetes, Docker streamlines the deployment and management of complex, distributed applications, making it an indispensable tool for modern software development workflows. For these reasons, Docker is used in this project.


Cloud computing is a transformative technology that offers numerous advantages for businesses and individuals alike. One of its primary benefits is the scalability it provides, allowing users to easily adjust computing resources based on demand, whether it's scaling up during peak periods or scaling down during slower times. This elasticity ensures optimal performance and cost efficiency. Cloud computing also enhances accessibility by enabling users to access their applications and data from anywhere with an internet connection, promoting collaboration and remote work capabilities. Moreover, cloud services offer a pay-as-you-go model, eliminating the need for large upfront investments in hardware and infrastructure. This cost-effective approach makes it easier for businesses to adopt cutting-edge technologies without a significant financial burden. Additionally, cloud providers handle essential aspects like maintenance, security, and updates, relieving organizations of the operational burden and allowing them to focus more on core business activities. Overall, cloud computing revolutionizes IT infrastructure, providing agility, cost savings, global accessibility, and simplified management, making it an indispensable asset for modern businesses and individuals in the digital age. For these reasons, AWS virtual machine (EC2) is used in this project.

## Setting Up Virtual Machine

As a solution to lower variable cost provisioning for the desired computing specifications, AWS virtual machine (EC2 Instance) will be used to contain docker application which later to be used to host the node JS application. To set up EC2 Instance:
1. Login to AWS console, and then access "EC2" resource in Service bar.
2. Once EC2 dashboard is fully rendered, click "Launch Instance"
3. Provide name to label EC2 Instance
4. Select the desired amazon machine image (AMI) to build the virtual machine, in this project "Amazon Linux 2023 AMI" is selected.
5. Select the type of image architecture, in this project "64bit(x86)" is selected.
6. Select instance type, in this project "t3.2xlarge" is selected. This instance type caters to 8 vCPU and 32 GiB Memory.
7. Create new key pair to login, in this project ".pem" file is created.
8. Configure security group to network setting depending on the use case, in this  project SSH traffic from anywhere is allowed, with additional inbound rules to allow HTTP traffic only from local pc.
9. Lastly, configure storage to be provisioned, in this project 100 GiB gp2 is selected. Finally click launch instance.
10. Once has been launched, EC2 can be access using SSH protocol via Public IPv4 address
```
    ssh -i <pem_file_name>.pem ubuntu@<ipv4_address>
```
11. To note, pem file needs to be configured to be read only before login via SSH protocol
```
chmod 400 <pem_file_name>.pem
```
Once set up, you can download this repository on your virtual machine.
```
git clone https://github.com/RevoU-FSSE-2/week-6-gkorompis
cd week-6-gkorompis
```

## Installing Docker
Docker can be installed by running this command:
```
chmod 777 install_docker.sh
./install_docker.sh
```
This bash script consists of,
1. Preparing necessary package update and installation
```
sudo yum update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```
2. Adding docker official GPG key
```
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
3. Setting up repository
```
echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
4. Installing docker engine
```
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
5. Verifying that installation is successful
```
sudo docker run hello-world
```
<img width="1329" alt="week6-ss1-docker" src="https://github.com/RevoU-FSSE-2/week-6-gkorompis/assets/52250424/b37a2f90-95c3-445d-97d9-09925923a9c1">

```
docker --version
```
<img width="881" alt="week6-ss2-docker-version" src="https://github.com/RevoU-FSSE-2/week-6-gkorompis/assets/52250424/3c22e47d-88e0-4fd8-bb39-9335a294179d">

## Application Deployment
1. Create working directory for Dockerfile and node JS file
2. Configure package.json that corresponds to application requirements
```
{
  "name": "Simple Server App",
  "version": "1.0.0",
  "description": "Simple server app for week 6 assignment",
  "main": "app.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "http": "^0.0.1-security"
  }
}
```
3. Configure Dockerfile to build the application image
```
#Pulling the latest node image to set up the prerequisite environment
FROM node:latest

#Defining working directory to execute subsequent commands inside the container
WORKDIR /app

#Copying all the files and directories from the host machine into the specified working directory inside the container. All files and directories that are listed in gitignore file will not be copied into the container.
COPY . .

#RUN will instruct docker to run npm install only during the image build process in order to install all necessary node JS packages as specified in package.json
RUN npm install

#CMD will instruct docker to run the command specified after, upon starting running the container
CMD ["node", "app.js"]
```
4. Build the image using the dockerfile. NOTE: the command needs to be run on the same location with Dockerfile and all the necessary application files
```
docker build -t <tag_name>
```
5. Verify the image has been built by running this command:
```
docker images
```
6. Start and server the application by running this command:
```
docker run -p 8000:3001 <tag_name>
```
7. Verify the container has been built by running this command:
```
docker ps
```
To note, in order to detach from docker session you may add -d when starting the container
```
docker run -d -p 8000:3001 <tag_name>
```
8. Stop the container by running this command:
```
docker stop <container_id>
```