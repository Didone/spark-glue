FROM amazon/aws-glue-libs:glue_libs_1.0.0_image_01
COPY conf/ "/home/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8/conf/"
RUN pip install pydeequ && \
    wget "https://repo1.maven.org/maven2/com/amazon/deequ/deequ/1.1.0_spark-2.4-scala-2.11/deequ-1.1.0_spark-2.4-scala-2.11.jar" && \
    mv deequ-1.1.0_spark-2.4-scala-2.11.jar /home/spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8/jars
CMD /home/jupyter/jupyter_start.sh
EXPOSE 8888