FROM ipynbsrv/base-ldap:latest
MAINTAINER Michel Käser <michel.kaeser@students.fhnw.ch>


#
# Rodeo template (Python3 version)
# https://github.com/yhat/rodeo/
# -----------------------------------------------
#
# Command: (leave empty)
# Protected Port: 8888
# Public Ports: 22 (inherited from base-ldap)
#


# update the package index for later installations
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# install system-wide pip and sed for fix
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python3-dev python3-pip sed
# install rodeo
RUN pip3 install rodeo
RUN pip3 install ipykernel

# 'fix' the rodeo package to work behind the proxy
# see: http://flask.pocoo.org/snippets/35/
ADD lib/ReverseProxied.py ReverseProxied.py
RUN cat /usr/local/lib/python3.4/dist-packages/rodeo/rodeo.py > /tmp/out
RUN cat ReverseProxied.py /tmp/out > /usr/local/lib/python3.4/dist-packages/rodeo/rodeo.py
RUN rm -f ReverseProxied.py
RUN sed -i "s|Flask(__name__)|Flask(__name__)\\napp.wsgi_app = ReverseProxied\(app.wsgi_app\)|" /usr/local/lib/python3.4/dist-packages/rodeo/rodeo.py

# copy my_init services into the container and make sure only root user can change it
ADD lib/rodeo-py3.bin /usr/local/bin/init_cmd
RUN chown root:root /usr/local/bin/init_cmd
RUN chmod 0644 /usr/local/bin/init_cmd
RUN chmod +x /usr/local/bin/init_cmd

# cleanup
RUN apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/*-


CMD ["/usr/local/bin/init_cmd"]
EXPOSE 8888
VOLUME ["/data"]
