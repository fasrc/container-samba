FROM centos:7
MAINTAINER FAS Research Computing <rchelp@rc.fas.harvard.edu>

RUN yum -y update && yum install -y epel-release wget samba samba-winbind samba-winbind-clients samba-winbind-modules sssd pam_krb5 pam_ldap krb5-workstation deltarpm && \
    yum install -y supervisor && \
    rm -rf /var/cache/yum/* /usr/share/doc/* && yum clean all

# Setup environmental variables
ENV JOIN_USER root
ENV JOIN_PASSWORD root
ENV SMB_CONF /etc/samba/smb.conf
ENV SMB_INCLUDE_CONF /etc/samba/smb_include.conf
ENV DC dc.domain
ENV HOSTNAME test_node

# samba config default variables
ENV DOMAIN 'test'
ENV REALM 'test.domain'
ENV SECURITY_MODE 'ADS'
ENV NAME_RESOLVE_ORDER 'hosts'
ENV LOG_LEVEL "all:5"
ENV LOG_SIZE 1000
ENV SOCKET_OPTIONS 'TCP_NODELAY IPTOS_LOWDELAY SO_SNDBUF=131072 SO_RCVBUF=131072'
ENV MAX_XMIT 131072
ENV GETWD_CACHE yes
ENV NAME_CACHE_TIMEOUT 660
ENV WINBIND_NSS_INFO 'rfc2307'
ENV WINBIND_USE_DOMAIN yes
ENV WINBIND_OFFLINE_LOGON yes
ENV WINBIND_ENUM_USERS yes
ENV WINBIND_ENUM_GROUPS yes
ENV WINBIND_SEPARATOR +
ENV WINBIND_NESTED_GROUPS yes
ENV WINBIND_REFRESH_TICKETS true
ENV WINBIND_MAX_CLIENTS 1000
ENV ENCRYPT_PASSWORDS yes
ENV ALLOW_TRUSTED_DOMAINS yes
ENV LOCAL_MASTER No
ENV DOMAIN_MASTER False
ENV PREFERRED_MASTER no
ENV PASSWORD_SERVER *
ENV CLIENT_USE_SPNEGO yes
ENV MAP_TO_GUEST 'bad user'
ENV IDMAP_BACKEND 'tdb'
ENV IDMAP_RANGE '100-665'
ENV IDMAP_DOMAIN_BACKEND 'ad'
ENV IDMAP_DOMAIN_RANGE '666-999999'
ENV SCHEMA_MODE 'rfc2307'
ENV RESTRICT_ANONYMOUS 2
ENV MAP_ACL_INHERIT yes
ENV INHERIT_ACLS yes
ENV LOAD_PRINTERS no
ENV PRINTING 'bsd'
ENV PRINTCAP_NAME '/dev/null'
ENV DISABLE_SPOOL yes
ENV INCLUDE_CONF '/etc/samba/smb_include.conf'

# share default variables
ENV SHARE_NAME 'test'
ENV AVAILABLE yes
ENV USE_SENDFILE yes
ENV WRITE_CACHE_SIZE 262144
ENV SHARE_PATH '/tmp'
ENV WRITEABLE yes
ENV CREATE_MASK '0770'
ENV DIRECTORY_MASK '0770'
ENV MAX_CONNECTIONS 100
ENV GUEST_OK no

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./startup /bin/startup
COPY ./smb.conf /etc/samba/smb.conf
COPY ./smb_include.conf /etc/samba/smb_include.conf

#RUN /usr/bin/wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64 && \
#    chmod +x /usr/local/bin/dumb-init

EXPOSE 137 139 445

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
