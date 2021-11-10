# our base image
FROM ubuntu:20.04
ARG service
ENV service "$service"
ENV VIRTUAL_HOST "${service}.lo"

ENV DEBIAN_FRONTEND=noninteractive

ARG PROJECT_NAME
ARG VIRTUAL_HOST
ARG PATH_SERVICES

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ansible \
    apt-transport-https \
    ca-certificates-java \
    curl \
    init \
    openssh-server openssh-client \
    unzip \
    rsync \
    sudo \
    fuse snapd snap-confine squashfuse \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Configure udev for docker integration
RUN dpkg-divert --local --rename --add /sbin/udevadm && ln -s /bin/true /sbin/udevadm

RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# ENTRYPOINT ["/sbin/init"]

# Add ansible related files to docker image
RUN echo "Using default Microservice.Dockerfile for Microservice $service"
ADD ./microservices/$service/provision.yml provision.yml
ADD ./shared/roles roles

# run provisioning
RUN ansible-playbook provision.yml -c local