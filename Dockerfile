FROM jenkins/jenkins:lts

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

USER root

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt \
    # download docker but only install the client
    && wget https://download.docker.com/linux/static/stable/x86_64/docker-17.06.2-ce.tgz \
    && tar xvzf docker-17.06.2-ce.tgz \
    && mv docker/docker /usr/bin/docker \
    && chmod +x /usr/bin/docker \
    && rm -rf docker/ \
    && groupadd docker \
    && usermod -aG staff,docker jenkins \
    # add ansible for continuous integration/deploy
    && apt-get update && apt-get install -yq python python-pip \
    && pip install ansible

USER jenkins
