FROM celery:latest

USER root
RUN pip install flower
RUN apt-get update -y
RUN apt-get install -y git
RUN mkdir /home/root
RUN git clone https://git.rackster.ch/ipynbsrv/common.git /home/root/common
RUN git clone https://git.rackster.ch/ipynbsrv/contract.git /home/root/contract
RUN git clone https://git.rackster.ch/ipynbsrv/backends.git /home/root/backends

#TODO: make install work
#RUN python /home/root/contract/setup.py install
#RUN python /home/root/common/setup.py install
#RUN python /home/root/backends/setup.py install


CMD celery flower --broker=$CELERY_BROKER_URL --inspect
