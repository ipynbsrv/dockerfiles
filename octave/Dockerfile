FROM ipynbsrv/base-ldap:latest
MAINTAINER Michel Käser <michel.kaeser@students.fhnw.ch>


#
# GNU Octave template
# -----------------------------------------------
#
# Command: (leave empty)
# Protected Port: (none)
# Public Ports: 22 (inherited from base-ldap)
#


# update the package index for later installations
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# install octave
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install octave

# cleanup
RUN apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/*-


VOLUME ["/data"]
