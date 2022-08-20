#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
JENKINS_HOME=/home/jenkins

yum update -y
yum upgrade
amazon-linux-extras install java-openjdk11

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl status amazon-ssm-agent
systemctl start amazon-ssm-agent

# Creates the jenkins user
adduser jenkins --shell /bin/bash
su jenkins
mkdir $JENKINS_HOME/jenkins_slave
mkdir $JENKINS_HOME/.ssh && cd $JENKINS_HOME/.ssh
ssh-keygen -t rsa -N '' -f $JENKINS_HOME/.ssh/id_rsa
cat id_rsa.pub > $JENKINS_HOME/.ssh/authorized_keys
chown -R jenkins $JENKINS_HOME/.ssh
chown -R jenkins $JENKINS_HOME/jenkins_slave
chmod 600 $JENKINS_HOME/.ssh/authorized_keys
chmod 700 $JENKINS_HOME/.ssh
su -

yum install docker -y
newgrp docker
usermod -a -G docker ec2-user
usermod -a -G docker jenkins
yum install python3-pip -y
yes | pip3 install docker-compose

# Enable docker service at AMI boot time:
systemctl enable docker.service
systemctl start docker.service
