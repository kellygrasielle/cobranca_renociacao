

# AWS Step Functions IAM roles and Policies
resource "aws_iam_role" "aws_stf_role" {
  name = "${var.project_name}-aws-stf-role-${var.resource_suffix_identification}"
  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":"sts:AssumeRole",
         "Principal":{
            "Service":[
                "states.amazonaws.com"
            ]
         },
         "Effect":"Allow",
         "Sid":"StepFunctionAssumeRole"
      }
   ]
}
EOF
}

resource "aws_iam_role_policy" "step_function_policy" {
  name = "aws-stf-policy"
  role    = aws_iam_role.aws_stf_role.id

  policy  = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":[
                "glue:StartJobRun",
                "glue:GetJobRun",
                "glue:GetJobRuns",
                "glue:BatchStopJobRun"
         ],
         "Effect":"Allow",
         "Resource":"*"
      }
  ]
}

EOF
}

# AWS Step function definition
resource "aws_sfn_state_machine" "aws_step_function_workflow" {
  name = "aws-step-function-workflow"
  role_arn = aws_iam_role.aws_stf_role.arn
  definition = <<EOF
{
   "Comment":"A description of the sample glue job state machine using Terraform",
   "StartAt":"Glue StartJobRun",
   "States":{
      "Glue StartJobRun":{
         "Type":"Task",
         "Resource":"arn:aws:states:::glue:startJobRun.sync",
         "Parameters":{
            "JobName":"${aws_glue_job.cria_dados_biro.name}",
            "Arguments": {
            }
         },
         "End":true
      }
   }
}
EOF

}


# outputs
output "stf_role_arn" {
  value = aws_iam_role.aws_stf_role.arn
}
output "stf_name" {
  value = aws_sfn_state_machine.aws_step_function_workflow
}
output "stf_arn" {
  value = aws_sfn_state_machine.aws_step_function_workflow.arn
}