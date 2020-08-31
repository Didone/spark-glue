FROM amazonlinux
# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html#develop-local-python
ARG MAVEN_REPO="https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz"
ARG SPARK_REPO="https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-1.0/spark-2.4.3-bin-hadoop2.8.tgz"
ARG GLUE_REPO="https://github.com/awslabs/aws-glue-libs/archive/glue-1.0.zip"
ARG AVRO_REPO="https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.11/2.4.0/spark-avro_2.11-2.4.0.jar"
ARG AWS_REGION="us-east-1"
# Install
ENV JAVA_HOME="/usr/lib/jvm/java-openjdk"\
    SPARK_HOME="/usr/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8"\
    MAVEN_HOME="/usr/apache-maven-3.6.0"\
    GLUE_HOME="/usr/aws-glue-libs-glue-1.0"\
    AWS_HOME="/root/.aws"
# Dependencies
RUN sed -i 's;^releasever.*;releasever=2017.03;;' /etc/yum.conf 
RUN yum clean all && yum update -y && yum groupinstall -y "Development Tools"
RUN yum install -y curl unzip wget java-1.8.0-openjdk-devel python3 snappy-devel gcc-c++
RUN curl -sL --retry 3 "${MAVEN_REPO}" | gunzip | tar -x -C /usr/ 
RUN curl -sL --retry 3 "${SPARK_REPO}" | gunzip | tar -x -C /usr/ 
RUN curl -sL --retry 3 "https://bootstrap.pypa.io/get-pip.py" -O 
RUN wget --quiet "${GLUE_REPO}" && unzip glue-1.0.zip -d  /usr/ && rm glue-1.0.zip
# Python
RUN pip3 install --upgrade setuptools pip
RUN pip3 install awscli boto3 jupyter tornado==5.1.1
# RUN pip3 install awswrangler avro-python3 python-snappy
# Env
ENV SPARK_CONF_DIR=${SPARK_HOME}/conf\
    M2_HOME=${MAVEN_HOME}\
    PATH=$PATH:${SPARK_HOME}/bin:${MAVEN_HOME}/bin
# Glue
WORKDIR ${GLUE_HOME}
RUN mkdir -p ${AWS_HOME} && \
    echo "[default]" > ${AWS_HOME}/config && \
    echo "region = ${AWS_REGION}" >> ${AWS_HOME}/config && \
    chmod +x bin/* && ./bin/glue-setup.sh && cp -Rf jarsv1/*.jar $SPARK_HOME/jars && \
    wget --quiet "${AVRO_REPO}" && mv spark-avro_2.11-2.4.0.jar $SPARK_HOME/jars
# Jupyter notebook
RUN cp -Rf awsglue/ $SPARK_HOME/python 
ENV PYSPARK_PYTHON="python3"\
    PYSPARK_DRIVER_PYTHON="jupyter"\
    PYTHONSTARTUP="pyspark"\
    JUPYTER_ALLOW_INSECURE_WRITES=true\
    JUPYTER_RUNTIME_DIR=/tmp\
    PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip='*' --allow-root --notebook-dir=/tmp/notebooks "
RUN yum -y install snappy snappy-devel python3-devel python-devel
RUN pip3 install python-snappy awswrangler==0.3.2 avro-python3
RUN pip3 install fsspec==0.6.3 PyAthena==1.10.2 s3fs==0.4.0
CMD pyspark