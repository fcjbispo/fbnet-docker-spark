FROM fcjbispo/fbnet-spark-base:3.4.1-hadoop3.3

LABEL maintainer="Francisco C J Bispo <fcjbispo@franciscobispo.net>"

HEALTHCHECK CMD curl -f http://localhost:8888/ || exit 

ARG SPARK_USER=fbnet

ENV SPARK_MASTER_NAME=spark-master
ENV SPARK_MASTER_PORT=7077
ENV JUPYTER_USER=$SPARK_USER
ENV JUPYTER_USER_PASSWD=_Admin123

COPY submit.sh /
COPY run.sh /
COPY requeriments.txt /

RUN apk add --no-cache --update alpine-sdk \
    && apk add --no-cache libffi-dev openssl-dev \
    && apk --no-cache add build-base python3-dev sudo \
    && apk --no-cache add openssh sshpass

RUN adduser -D -s /bin/bash $JUPYTER_USER \ 
    && adduser $JUPYTER_USER wheel \
    && echo "$JUPYTER_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "$JUPYTER_USER:$JUPYTER_USER_PASSWD" | chpasswd

RUN mkdir -pv /var/jupyter \
    && chown -R $SPARK_USER:$SPARK_USER /var/jupyter \
    && python -m venv /home/$SPARK_USER/.local \
    && source ./home/$SPARK_USER/.local/bin/activate \
    && pip install -r /requeriments.txt

COPY /jupyterlab.sh /home/$SPARK_USER/jupyterlab.sh

VOLUME /var/jupyter 

EXPOSE 8888

RUN echo "export PATH=/home/$SPARK_USER/.local/bin:$PATH" >> /home/$SPARK_USER/.bashrc
RUN echo "source /home/$SPARK_USER/.local/bin/activate" >> /home/$SPARK_USER/.bashrc

RUN chown -R $SPARK_USER:$SPARK_USER /home/$SPARK_USER

ENV HADOOP_NAMENODE_NAME=namenode
ENV HADOOP_NAMENODE_PORT=9000

CMD [ "/bin/bash", "/run.sh" ]
