resource "aws_glue_job" "cria_dados_biro" {
  name     = "${var.project_name}-cria-dados-biro-${var.resource_suffix_identification}"
  role_arn = aws_iam_role.glue.arn
  glue_version = "4.0"
  worker_type       = "Standard"
  number_of_workers = 2

  command {
    python_version  = "3"
    script_location              = "s3://${aws_s3_bucket.glue-scripts.bucket}/${aws_s3_object.cria_dados_biro_script.key}"
  }

  default_arguments = {
      # ... potentially other arguments ...
      "--continuous-log-logGroup"          = "${aws_cloudwatch_log_group.cobra_by_email_group.name}"
      "--enable-continuous-cloudwatch-log" = "true"
      "--enable-continuous-log-filter"     = "true"
      "--enable-metrics"                   = ""
      "--bucket-biro"                     = "s3://${aws_s3_bucket.biro.bucket}/"
      "--table"                           = "${aws_dynamodb_table.payments.name}"

    }

}

resource "aws_cloudwatch_log_group" "cobra_by_email_group" {
  name              = "${var.project_name}-cobranca_by_email-${var.resource_suffix_identification}"
  retention_in_days = 3
}


