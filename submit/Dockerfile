FROM fcjbispo/fbnet-spark-base:3.4.1-hadoop3.3

LABEL maintainer="Francisco C J Bispo <fcjbispo@franciscobispo.net>"

ENV SPARK_MASTER_NAME spark-master
ENV SPARK_MASTER_PORT 7077

COPY submit.sh /

CMD ["/bin/bash", "/submit.sh"]
