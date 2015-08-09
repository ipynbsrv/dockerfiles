FROM phusion/baseimage:0.9.17
MAINTAINER FHNW <michel.kaeser@students.fhnw.ch>


#
# ipynbsrv Docker container backend base template
# (ipynbsrv.backends.container_backends.Docker)
# -----------------------------------------------
#
# This template should be used as a base for all images being made available to users.
#
# It ensures:
#
#   - the container is configured to use the internal LDAP server for authentication
#   - the SSH service is running and started on boot, so the user can enter the container
#   - only the user owning the container can enter
#
# For the last to work, make sure you provide:
#
#   - the OWNER environment variable upon container creation (the backend will do that for you)
#
# This template makes some assumptions/has requirements:
#
#   - the LDAP server is available at 192.168.0.1 (change otherwise)
#   - the container's local working dir is /data
#   - public directories are mounted to /data/public
#   - shares are mounted to /data/shares
#   - home directories are mounted to /home
#
# Currently not implemented but needed:
#
#   - a way to prevent password changes
#   - proper cleanup/regen of SSH keys
#
# The following environment variables are set:
#
#   - OWNER: The username of the container owner
#


# update the package index for later installations
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# lock down the root user
RUN passwd -d root && passwd -l root

# enable the SSH service
RUN rm -f /etc/service/sshd/down
# allow password based SSH login
RUN echo "UsePAM yes" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# allow only defined users to enter the container
# http://www.cyberciti.biz/tips/howto-deny-allow-linux-user-group-login.html
# http://www.cyberciti.biz/faq/bash-prepend-text-lines-to-file/
RUN touch /etc/login.user.allowed
RUN sed -i '1i auth required pam_listfile.so item=user sense=allow file=/etc/login.user.allowed onerr=fail' /etc/pam.d/common-auth

# install and configure the LDAP package
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libpam-ldapd
# comment defaults out
RUN sed -i 's/compat/compat ldap/' /etc/nsswitch.conf
RUN sed -i 's/uri/#uri/' /etc/nslcd.conf
RUN sed -i 's/base/#base/' /etc/nslcd.conf
# FIXME: these should be provided via ENV, not be hardcoded
# set new values based on ipynbsrv defaults
RUN echo "uri ldap://192.168.0.1/" >> /etc/nslcd.conf
RUN echo "base ou=groups,dc=ipynbsrv,dc=ldap" >> /etc/nslcd.conf
RUN echo "base ou=users,dc=ipynbsrv,dc=ldap" >> /etc/nslcd.conf

# override some defaults defined in LDAP (if none is set and for security)
RUN echo "nss_override_attribute_value loginShell /bin/bash" >> /etc/ldap/ldap.conf

# script to perform system checks
COPY etc/my_init.d/01_check_environment.sh /etc/my_init.d/01_check_environment.sh
RUN chmod +x /etc/my_init.d/01_check_environment.sh

# ensure the LDAP required daemons start on boot
COPY etc/my_init.d/02_start_ldap_services.sh /etc/my_init.d/02_start_ldap_services.sh
RUN chmod +x /etc/my_init.d/02_start_ldap_services.sh

# provide the script setting owner permissions etc.
COPY etc/my_init.d/03_prepare_for_owner.sh /etc/my_init.d/03_prepare_for_owner.sh
RUN chmod +x /etc/my_init.d/03_prepare_for_owner.sh

# prepare the volume directories
RUN mkdir /data
RUN chmod 0777 /data
RUN mkdir /data/public
RUN mkdir /data/shares

# cleanup
RUN apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/*-


ENTRYPOINT ["/sbin/my_init", "--"]
ENV OWNER ""
EXPOSE 22

VOLUME /data/public
VOLUME /data/shares
VOLUME /home
