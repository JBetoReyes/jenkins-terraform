#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y
sudo yum upgrade
sudo yum install -y java-1.8.0-openjdk git

useradd -d /var/lib/jenkins jenkins
mkdir /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/authorized_keys
ssh-keygen -t rsa -N '' -f /var/lib/jenkins/.ssh/id_rsa
cat /var/lib/jenkins/.ssh/id_rsa.pub > /var/lib/jenkins/.ssh/authorized_keys
chown -R jenkins /var/lib/jenkins/.ssh
chmod 600 /var/lib/jenkins/.ssh/authorized_keys
chmod 700 /var/lib/jenkins/.ssh