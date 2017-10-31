FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y curl git less
ADD provision_jenkins.sh /usr/bin/
ADD install_jenkins_plugins.sh /usr/bin/
ADD default_jenkins_plugins /tmp/
USER jenkins
