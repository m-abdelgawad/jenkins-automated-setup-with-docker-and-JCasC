FROM jenkins/jenkins:lts-jdk11

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY casc.yaml /var/jenkins_home/casc.yaml

# Use user root to perform initial setup
USER root

# Download Docker binary and extract it to the appropriate location
RUN curl -L https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xz -C /usr/local/bin/ --strip-components=1 docker/docker

# Create a new group named "docker" with GID the same as the docker group on
# your host machine. You can get it with the command: getent group docker
RUN groupadd -g 121 docker

# Add the Jenkins user to the "staff" and "docker" groups
RUN usermod -aG docker jenkins

# Install Python
RUN apt-get update
RUN apt-get install -y python3-pip

# Switch back to the Jenkins user
USER jenkins
