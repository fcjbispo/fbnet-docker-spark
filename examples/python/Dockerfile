FROM fcjbispo/fbnet-spark-python-template:3.4.1-hadoop3.3
	  
COPY wordcount.py /app/

ENV SPARK_APPLICATION_PYTHON_LOCATION /app/wordcount.py
ENV SPARK_APPLICATION_ARGS "/spark/README.md"