#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Home"
echo $HOME

EC2_HOME=/home/ec2-user
sudo yum update –y

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl status amazon-ssm-agent
systemctl start amazon-ssm-agent

yum install docker -y
usermod -a -G docker ec2-user
newgrp docker
yum install python3-pip -y
yes | pip3 install docker-compose

# Enable docker service at AMI boot time:
systemctl enable docker.service
systemctl start docker.service

mkdir $EC2_HOME/jenkins_home

# Jenkins plugins
touch $EC2_HOME/plugins.txt
tee -a $EC2_HOME/plugins.txt <<EOF
docker:latest
docker-pipeline:latest
configuration-as-code:latest
cloudbees-folder:latest
antisamy-markup-formatter:latest
build-timeout:latest
credentials-binding:latest
timestamper:latest
ws-cleanup:latest
ant:latest
gradle:latest
workflow-aggregator:latest
github-branch-source:latest
pipeline-github-lib:latest
pipeline-stage-view:latest
git:latest
ssh-slaves:latest
matrix-auth:latest
pam-auth:latest
ldap:latest
email-ext:latest
mailer:latest
EOF

# Jenkins casc.yaml
touch $EC2_HOME/jenkins_home/casc.yaml
tee -a $EC2_HOME/jenkins_home/casc.yaml <<EOF
jenkins:
  securityRealm:
    local:
      allowsSignup: false
      users:
       - id: \${JENKINS_ADMIN_ID}
         password: \${JENKINS_ADMIN_PASSWORD}
unclassified:
  location:
    url: http://server_ip:8080/
EOF

# Dockerfile
touch $EC2_HOME/Dockerfile
tee -a $EC2_HOME/Dockerfile <<EOF
FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
EOF

chown -R ec2-user $EC2_HOME

cd $EC2_HOME

docker build -t jenkins:wizardless .

docker run --rm -p 8080:8080  --env JENKINS_ADMIN_ID=beto --env JENKINS_ADMIN_PASSWORD=admin2342 -v $EC2_HOME/jenkins_home:/var/jenkins_home --name jenkins jenkins:wizardless
