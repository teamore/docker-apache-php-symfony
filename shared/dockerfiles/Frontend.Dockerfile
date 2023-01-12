# our base image
FROM ubuntu:20.04
ARG service
ENV service "$service"
ENV VIRTUAL_HOST "${service}.lo"

ARG PROJECT_NAME
ARG VIRTUAL_HOST
ARG PATH_SERVICES
ARG PHP_VERSION

ENV projectName "${PROJECT_NAME}"
ENV virtualHost "${VIRTUAL_HOST}"
ENV phpVersion "${PHP_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive

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
RUN echo "preparing frontend server [$virtualHost] for project [$projectName] with php[$phpVersion]"
RUN echo "Using default Frontend.Dockerfile for Service [$service]"
ADD ${PATH_SERVICES}/$service/provision.yml provision.yml
ADD ./shared/roles roles
COPY ${PATH_SERVICES}/$service/scripts/post_install.sh scripts/

RUN mkdir -p /etc/apache2/ssl

# run provisioning
RUN ansible-playbook provision.yml -c local --extra-vars "PHP_VERSION=${PHP_VERSION} PROJECT_NAME=${PROJECT_NAME} VIRTUAL_HOST=${VIRTUAL_HOST}"

# run additional install scripts
RUN ["chmod", "+x", "./scripts/post_install.sh"]
RUN ./scripts/post_install.sh