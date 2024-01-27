provider "aws" {
  region = "us-west-2"
  access_key = "AKIASU4DCVL2FAS4EGNP"
  secret_key = "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"

}

resource "aws_dynamodb_table" "debit" {
  name           = "debit"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "due_payment_date"
  range_key      = "contract"

    attribute {
      name = "due_payment_date"
      type = "S"
    }

    attribute {
      name = "contract"
      type = "S"
    }
}