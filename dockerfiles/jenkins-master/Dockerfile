FROM jenkins/jenkins:2.366

USER root

# install packages
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install sudo curl bash jq python3 python3-pip

# install AWS CLI
RUN set +x \
  && pip3 install awscli --upgrade

# list installed software versions
RUN set +x \
    && echo ''; echo '*** INSTALLED SOFTWARE VERSIONS ***';echo ''; \
    cat /etc/*release; python3 --version; \
    pip3 --version; aws --version;

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# copy plugins to /usr/share/jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml
# change directory owner for jenkins home
RUN chown -R jenkins:jenkins /var/jenkins_home
# drop back to the regular jenkins user - good practice
USER jenkins
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt