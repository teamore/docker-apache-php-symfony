# our base image
FROM ubuntu:18.04
ARG service
ENV service "$service"
ENV VIRTUAL_HOST "${service}.lo"

# Install ansible
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update && apt-get install -y ansible
RUN echo 'localhost ansible_connection=local' >> /etc/ansible/hosts

# Add ansible related files to docker image
RUN echo "Using default Microservice.Dockerfile for Microservice $service"
ADD ./microservices/$service/provision.yml provision.yml
ADD ./shared/roles roles

# run provisioning
RUN ansible-playbook provision.yml -c local
