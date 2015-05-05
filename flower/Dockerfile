FROM celery:latest

USER root
RUN pip install flower

CMD celery flower --broker=$CELERY_BROKER_URL --inspect
