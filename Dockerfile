FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y curl git less
# drop back to the regular jenkins user - good practice
USER jenkins
ADD provision_jenkins.sh /usr/bin/
ADD install_jenkins_plugins.sh /usr/bin/
ADD default_jenkins_plugins /tmp/
