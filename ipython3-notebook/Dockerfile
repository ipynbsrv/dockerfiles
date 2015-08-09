FROM ipynbsrv/base-ldap:latest
MAINTAINER Michel Käser <michel.kaeser@students.fhnw.ch>


#
# IPython Notebook template (Python3 version)
# -----------------------------------------------
#
# Command: (leave empty)
# Protected Port: 8888
# Public Ports: 22 (inherited from base-ldap)
#


# update the package index for later installations
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# install system-wide pip for IPython
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3-dev python3-pip
# install IPython + Notebook
RUN pip3 install terminado
RUN pip3 install "ipython[notebook]"

# packages and modules needed by nbconvert or .html/.pdf export
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pandoc
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra
RUN pip install pygments

# copy my_init services into the container and make sure only root user can change it
ADD ipython3-notebook.bin /usr/local/bin/init_cmd
RUN chown root:root /usr/local/bin/init_cmd
RUN chmod 0644 /usr/local/bin/init_cmd
RUN chmod +x /usr/local/bin/init_cmd

# cleanup
RUN apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/*-


CMD ["/usr/local/bin/init_cmd"]
ENV BASE_URL ""
EXPOSE 8888
VOLUME ["/data"]
