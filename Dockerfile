FROM alpine:3.4
MAINTAINER FAS Research Computing <rchelp@rc.fas.harvard.edu>

RUN apk add --no-cache bash samba samba-winbind samba-winbind-clients samba-libnss-winbind tdb linux-pam nss-pam-ldapd && rm -rf /var/cache/apk/*

# Setup environmental variables
ENV JOIN_USER root
ENV JOIN_PASSWORD root
ENV SMB_CONF /etc/samba/smb.conf
ENV SMB_INCLUDE_CONF /etc/samba/samba_include.conf

COPY ./startup /bin/startup

COPY ./dumb-init /bin/dumb-init

EXPOSE 137 139 445

#WORKDIR /var/samba
ENTRYPOINT ["/bin/dumb-init", "/bin/startup", "-j", "-w"]
