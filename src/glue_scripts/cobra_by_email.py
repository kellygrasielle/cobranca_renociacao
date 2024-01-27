try:
    from awsglue.transforms import *
    from awsglue.utils import getResolvedOptions
    from pyspark.context import SparkContext
    from awsglue.context import GlueContext
    from awsglue.job import Job
    from datetime import date
    import sys, json, uuid, boto3, ast, time, re
    from awsglue.dynamicframe import DynamicFrame
    from boto3.dynamodb.conditions import Key
    from datetime import datetime, timedelta

except Exception as e:
    print("Error*** : {}".format(e))

args = getResolvedOptions(sys.argv, ["JOB_NAME","table","bucket-biro"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)
limit_days=5
today = date.today()  - timedelta(days=limit_days)
today_format = str(today.year) + str(today.month) + str(today.day)
bucket_bira_json = "s3://cobra-biro-dev//"+today_format

def get_payment_pending_to_neg(dynamodb_table):
    try:
        print("inicializando busca DyanamoDB")
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(dynamodb_table)
        print("Querying all payments penging for more than %s", limit_days)

        response = table.query(
            KeyConditionExpression=Key('status').eq(
                "PENDENTE") & Key('due_payment_date_contract').lte("20250131") ,
        )

        if not 'Items' in response or len(response['Items']) == 0:
            print("no itens")
            return None
        else:
            return   spark.createDataFrame(response['Items'])
    except Exception as error:
        print("Error getting the payments: %s", error)
        raise error

def assemble_biro_file(rec):
    negativar = {
        "source": "BANCO ITAU",
        "cpf": rec["cpf"],
        "nome": rec["nome"],
        "vencimento": rec["due_payment_date"],
        "data_envio": date.today()
    }
    return negativar

if __name__ == "__main__":
    try:
        print("Starting BIRO files creation. Glue Job%: ")

        debit_df = get_payment_pending_to_neg(args["table"])
        debit_dynamic = DynamicFrame.fromDF(debit_df, glueContext, "debit_dynamic")

        result = debit_dynamic.map(f = assemble_biro_file)
        result = result.toDF()
        result.write.format("org.apache.spark.sql.json").mode('append').save(bucket_bira_json);

    except Exception as error:
        print(error)
        raise error