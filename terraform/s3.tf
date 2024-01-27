resource "aws_s3_bucket" "glue-scripts" {
  bucket = "${var.project_name}-${var.bucket_code_python}-${var.resource_suffix_identification}"

}

resource "aws_s3_bucket" "biro" {
  bucket = "${var.project_name}-${var.bucket_biro}-${var.resource_suffix_identification}"

}

resource "aws_s3_object" "code_cobra_by_email_job" {
  key    = "code_cobra_by_email_job"
  bucket = aws_s3_bucket.glue-scripts.id
  source = "../src/glue_scripts/cobra_by_email.py"

  tags = {
    Env = "test"
  }
}
