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

RUN apk add --no-cache --update alpine-sdk \
    && apk add --no-cache libffi-dev openssl-dev rust cargo \
    && apk --no-cache --update add build-base python3-dev sudo

RUN adduser -D -s /bin/bash $JUPYTER_USER \ 
    && adduser $JUPYTER_USER wheel \
    && echo "$JUPYTER_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "$JUPYTER_USER:$JUPYTER_USER_PASSWD" | chpasswd

RUN mkdir -pv /var/jupyter \
    && chown -R $SPARK_USER:$SPARK_USER /var/jupyter \
    && python -m venv /home/$SPARK_USER/.local \
    && source ./home/$SPARK_USER/.local/bin/activate \
    && pip install ipython jupyterlab \
        jupytext pyspark==3.4.1 pandas requests sqlalchemy \
        matplotlib scikit-learn seaborn theano keras

COPY /jupyterlab.sh /home/$SPARK_USER/jupyterlab.sh

VOLUME /var/jupyter 

EXPOSE 8888

RUN apk add --no-cache --update openjdk8 gnupg

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS

RUN gpg --import KEYS

ENV HADOOP_VERSION 3.3.6
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /home/$SPARK_USER/.bashrc
RUN echo "export HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}" >> /home/$SPARK_USER/.bashrc
RUN echo "export PATH=/home/$SPARK_USER/.local/bin:$JAVA_HOME/bin:$HADOOP_HOME/bin:$PATH" >> /home/$SPARK_USER/.bashrc
RUN echo "export CLASSPATH=`$HADOOP_HOME/bin/hdfs classpath --glob`" >> /home/$SPARK_USER/.bashrc
RUN echo "source /home/$SPARK_USER/.bin/activate" >> /home/$SPARK_USER/.bashrc

RUN chown -R $SPARK_USER:$SPARK_USER /home/$SPARK_USER

CMD [ "/bin/bash", "/run.sh" ]
