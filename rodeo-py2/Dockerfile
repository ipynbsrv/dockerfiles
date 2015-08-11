FROM ipynbsrv/base-ldap:latest
MAINTAINER Michel Käser <michel.kaeser@students.fhnw.ch>


#
# Rodeo template (Python2 version)
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
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-dev python-pip sed
# install rodeo
RUN pip install rodeo

# 'fix' the rodeo package to work behind the proxy
# see: http://flask.pocoo.org/snippets/35/
RUN echo "class ReverseProxied(object):
    def __init__(self, app):
        self.app = app

    def __call__(self, environ, start_response):
        script_name = environ.get('HTTP_X_SCRIPT_NAME', '')
        if script_name:
            environ['SCRIPT_NAME'] = script_name
            path_info = environ['PATH_INFO']
            if path_info.startswith(script_name):
                environ['PATH_INFO'] = path_info[len(script_name):]

        scheme = environ.get('HTTP_X_SCHEME', '')
        if scheme:
            environ['wsgi.url_scheme'] = scheme
        return self.app(environ, start_response)
        "|cat - /usr/local/lib/python2.7/dist-packages/rodeo/rodeo.py > /tmp/out && mv /tmp/out /usr/local/lib/python2.7/dist-packages/rodeo/rodeo.py

RUN sed -i "s|Flask(__name__)|Flask(__name__)\\napp.wsgi_app = ReverseProxied\(app.wsgi_app\)|" /usr/local/lib/python2.7/dist-packages/rodeo/rodeo.py

# copy my_init services into the container and make sure only root user can change it
ADD rodeo.bin /usr/local/bin/init_cmd
RUN chown root:root /usr/local/bin/init_cmd
RUN chmod 0644 /usr/local/bin/init_cmd
RUN chmod +x /usr/local/bin/init_cmd

# cleanup
RUN apt-get -y autoremove && apt-get -y autoclean && apt-get -y clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/*-


CMD ["/usr/local/bin/init_cmd"]
EXPOSE 8888
VOLUME ["/data"]
