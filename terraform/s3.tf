resource "aws_s3_bucket" "glue-scripts" {
  bucket = "${var.project_name}-${var.bucket_code_python}-${var.resource_suffix_identification}"

}

resource "aws_s3_bucket" "biro" {
  bucket = "${var.project_name}-${var.bucket_biro}-${var.resource_suffix_identification}"

}

resource "aws_s3_object" "cria_dados_biro_script" {
  key    = "${var.project_name}-cria-dados-biro-script"
  bucket = aws_s3_bucket.glue-scripts.id
  source = "../src/glue_scripts/criar_dados_biro.py"

  tags = {
    Env = "test"
  }
}
