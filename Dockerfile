FROM centos:7
MAINTAINER FAS Research Computing <rchelp@rc.fas.harvard.edu>

# Update system, despite a warning against this: https://docs.docker.com/articles/dockerfile_best-practices/#run
RUN yum -y update && yum install -y samba samba-winbind && yum clean all

# Setup environmental variables
ENV JOIN_USER root
ENV JOIN_PASSWORD root
ENV SMB_CONF /etc/samba/smb.conf
ENV SMB_INCLUDE_CONF /etc/samba/samba_include.conf

COPY ./startup /bin/startup

COPY ./dumb-init /bin/dumb-init

EXPOSE 137 139 445

#WORKDIR /var/samba
ENTRYPOINT ["/bin/dumb-init", "/bin/startup"]
