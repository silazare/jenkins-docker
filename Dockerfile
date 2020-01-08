ARG JENKINS_VERSION=2.213

FROM jenkins/jenkins:${JENKINS_VERSION}

ARG DOCKER_COMPOSE_VERSION=1.25.0
ARG DOCKER_GID=998

USER root

RUN set -ex && \
    apt-get -qq update && \
    apt-get -qq upgrade -y && \
    apt-get -qq -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      git \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
    apt-get -qq update && \
    apt-get -qq -y install docker-ce && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN set -ex && \
    curl -fsSL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN set -ex && \
    groupmod -g ${DOCKER_GID} docker && \
    usermod -aG docker jenkins && \
    gpasswd -a jenkins docker

USER jenkins

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY configs/security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

COPY configs/plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
