FROM rundeck/rundeck:3.2.7

USER root

RUN apt-get update && apt-get install -y apt-transport-https && \
    echo 'deb https://dl.bintray.com/rundeck/rundeck-deb /' >> /etc/apt/sources.list && \
    curl https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add -

RUN apt-get update && apt-get install -y python3 python3-pip git dos2unix zip rundeck-cli && \
    pip3 install ansible==2.9.5

USER rundeck

RUN wget https://github.com/Batix/rundeck-ansible-plugin/releases/download/3.1.1/ansible-plugin-3.1.1.jar \
    -P /home/rundeck/libext

COPY --chown=rundeck:root project/ /tmp/project/
RUN cd /tmp/project && zip -r ../project.jar * && rm -Rf /tmp/project
