# Spark for Glue development

Imagem utilizada para o desenvolvimento, testes e debug de códigos *Spark* para o desenvolvimento de *Glue Jobs*.

# Run

As conexões aos serviços aws são feitos através da **Access Key** e **Secret Key** do usuário *IAM* que deverão ser passadas para o container como variáveis de ambiente (`AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`)

```sh
docker run -v $(pwd)/notebooks:/home/jupyter/jupyter_default_dir -p 8888:8888 -p 4040:4040 didone/spark-glue
```

You can access your envinroment on <http://localhost:8888>

![tripdata.ipynb](https://raw.githubusercontent.com/Didone/spark-glue/master/img/notebook.png)

### Portas

+ Jupyter Notebook: `8888`
+ Console Spark: `4040`

## Build

Caso queira gerar sua própria imagem utilize os argumentos de build (`--build-arg`) para determinar as versões dos serviços que serão utilizados:

+ [MAVEN_REPO](http://maven.apache.org)
+ [SPARK_REPO](https://spark.apache.org)
+ [GLUE_REPO](https://docs.aws.amazon.com/glue/latest/dg/aws-glue-api-jobs-job.html)
+ [AVRO_REPO](http://avro.apache.org)

> Estes argumentos são opcionais, o build utilizará os parametros padrão caso nenhum valor seja valor informado

```sh
docker image build -t <<IMG_NAME> .
```
