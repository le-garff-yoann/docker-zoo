FROM centos:7

RUN yum -y update && yum install -y python3 openssh openssh-server
RUN systemctl enable sshd

RUN ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -qN "" && \
    cat /root/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 644 ~/.ssh/authorized_keys
