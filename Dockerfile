FROM centos:7
MAINTAINER FAS Research Computing <rchelp@rc.fas.harvard.edu>

# Update system, despite a warning against this: https://docs.docker.com/articles/dockerfile_best-practices/#run
RUN yum -y update && yum install -y samba samba-winbind sssd pam_krb5 pam_ldap krb5-workstation wget && \
    rm -rf /var/cache/yum/* /usr/share/doc/* && yum clean all

# Setup environmental variables
ENV JOIN_USER root
ENV JOIN_PASSWORD root
ENV SMB_CONF /etc/samba/smb.conf
ENV SMB_INCLUDE_CONF /etc/samba/samba_include.conf

COPY ./startup /bin/startup

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64 && \
    chmod +x /usr/local/bin/dumb-init

EXPOSE 137 139 445

#WORKDIR /var/samba
ENTRYPOINT ["/usr/local/bin/dumb-init", "/bin/startup", "-j", "-w", "-n", "-S"]
