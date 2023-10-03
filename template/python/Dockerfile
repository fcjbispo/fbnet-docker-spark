FROM fcjbispo/fbnet-spark-submit:3.4.1-hadoop3.3

LABEL maintainer="Francisco C J Bispo <fcjbispo@franciscobispo.net>"

COPY template.sh /

# Copy the requirements.txt first, for separate dependency resolving and downloading
ONBUILD COPY requirements.txt /app/
ONBUILD RUN cd /app \
      && pip3 install -r requirements.txt

# Copy the source code
ONBUILD COPY . /app

CMD ["/bin/bash", "/template.sh"]
