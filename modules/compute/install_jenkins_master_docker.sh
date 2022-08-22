#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "bucket name"
echo "${bucket_name}"

EC2_HOME=/home/ec2-user
EC2_IP=$(wget -q -O -  http://169.254.169.254/latest/meta-data/public-ipv4)
sudo yum update –y

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl status amazon-ssm-agent
systemctl start amazon-ssm-agent

yum install docker -y
newgrp docker
usermod -a -G docker ec2-user
yum install python3-pip -y
yes | pip3 install docker-compose

# Enable docker service at AMI boot time:
systemctl enable docker.service
systemctl start docker.service

mkdir $EC2_HOME/jenkins_home $EC2_HOME/.ssh
cd $EC2_HOME

# Nodes private key
aws s3api get-object --bucket ${bucket_name} --key keys/id_rsa .ssh/id_rsa
# restrict the access to keys
chmod 700 $EC2_HOME/.ssh
cp $EC2_HOME/.ssh/id_rsa $EC2_HOME/jenkins_home/id_rsa

# Configuration as code file for jenkins
aws s3api get-object --bucket ${bucket_name} --key master/casc.yaml jenkins_home/casc.yaml

# Jenkins plugins
aws s3api get-object --bucket ${bucket_name} --key master/plugins.txt plugins.txt

# Dockerfile
aws s3api get-object --bucket ${bucket_name} --key master/Dockerfile Dockerfile

chown -R ec2-user $EC2_HOME

echo "current directory"
pwd | echo 

docker build -t jenkins:wizardless .

docker run --rm -p 8080:8080  \
    --env JENKINS_ADMIN_ID=beto \
    --env JENKINS_ADMIN_PASSWORD=admin2342 \
    --env NODE_ONE_IP=${node_one_ip} \
    --env NODE_TWO_IP=${node_two_ip} \
    --env JENKINS_IP=$EC2_IP \
    -v $EC2_HOME/jenkins_home:/var/jenkins_home \
    --name jenkins jenkins:wizardless
