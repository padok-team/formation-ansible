# Dockerfile for building Ansible image for Alpine 3, with as few additional software as possible.
#
# @see https://github.com/gliderlabs/docker-alpine/blob/master/docs/usage.md
#
# Version  1.0
#
#LABEL William Yeh <william.pjyeh@gmail.com>

# pull base image
FROM alpine:3.8

# Install ansible
RUN echo "===> Installing sudo to emulate normal OS behavior..."
RUN apk --update add sudo                                       
RUN echo "===> Adding Python runtime..."
RUN apk --update add python py-pip openssl ca-certificates
RUN apk --update add --virtual build-dependencies python-dev libffi-dev openssl-dev build-base
RUN pip install --upgrade pip cffi
RUN echo "===> Installing Ansible..."
RUN pip install ansible
RUN echo "===> Installing handy tools (not absolutely required)..."
RUN pip install --upgrade pycrypto pywinrm
RUN apk --update add sshpass openssh-client rsync
RUN echo "===> Removing package list..."
RUN apk del build-dependencies
RUN rm -rf /var/cache/apk/*
RUN echo "===> Adding hosts for convenience..."
RUN mkdir -p /etc/ansible

COPY ./playbook/ansible.cfg /etc/ansible/
COPY ./playbook/*.yml /etc/ansible/
COPY ./playbook/hosts /etc/ansible/
COPY ./playbook/roles /etc/ansible/playbook/

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]