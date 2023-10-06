FROM fcjbispo/fbnet-spark-base:3.4.1-hadoop3.3

LABEL maintainer="Francisco C J Bispo <fcjbispo@franciscobispo.net>"

HEALTHCHECK CMD curl -f http://localhost:8888/ || exit 

ARG SPARK_USER=fbnet

ENV SPARK_MASTER_NAME=spark-master
ENV SPARK_MASTER_PORT=7077

COPY submit.sh /submit.sh
COPY run.sh /run.sh

RUN apk add --no-cache --update alpine-sdk \
    && apk add --no-cache libffi-dev openssl-dev \
    && apk --no-cache --update add build-base python3-dev sudo

RUN adduser -D -s /bin/bash $SPARK_USER \ 
    && adduser $SPARK_USER wheel

RUN mkdir -pv /var/jupyter \
    && chown -R $SPARK_USER:$SPARK_USER /var/jupyter \
    && python -m venv /home/$SPARK_USER/.local \
    && source ./home/$SPARK_USER/.local/bin/activate \
    && pip install ipython jupyterlab jupytext pyspark==3.4.1 pandas requests sqlalchemy matplotlib scikit-learn seaborn theano keras

COPY /jupyterlab.sh /home/$SPARK_USER/jupyterlab.sh

RUN chown -R $SPARK_USER:$SPARK_USER /home/$SPARK_USER

VOLUME /var/jupyter 

EXPOSE 8888

CMD ["/bin/bash", "/run.sh", ${SPARK_USER}]
