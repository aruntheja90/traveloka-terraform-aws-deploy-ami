data "aws_iam_policy_document" "codepipeline-deploy-ami-s3" {
  statement {
    effect = "Allow",
    actions = [
        "s3:GetBucketVersioning"
    ]
    resources = [
        "arn:aws:s3:::${var.service-s3-bucket}"
    ]
  }
  statement {
    effect = "Allow",
    actions = [
        "s3:GetObject",
        "s3:GetObjectVersion"
    ]
    resources = [
        "arn:aws:s3:::${var.service-s3-bucket}/${local.common-pipeline-name}/${var.service-name}.zip",
        "arn:aws:s3:::${var.service-s3-bucket}/${local.common-pipeline-name}/instance-ami-id-${var.environment}.tfvars"
    ]
  }
  statement {
    effect = "Allow",
    actions = [
        "s3:PutObject"
    ]
    resources = [
        "arn:aws:s3:::${var.service-s3-bucket}/*"
    ]
  }
  statement {
    effect = "Allow",
    actions = [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
    ]
    resources = [ 
      "arn:aws:codebuild:*:${data.aws_caller_identity.current.account_id}:project/${aws_codebuild_project.deploy-ami-plan.name}",
      "arn:aws:codebuild:*:${data.aws_caller_identity.current.account_id}:project/${aws_codebuild_project.deploy-ami-apply.name}"
    ]
  }
}

resource "aws_iam_role" "codepipeline-deploy-ami" {
  name = "CodePipelineDeployAmi-${var.service-name}-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline-assume.json}"
}

resource "aws_iam_role_policy" "codepipeline-deploy-ami-s3" {
  name = "CodePipelineAmiDeployAmi-${var.service-name}-${var.environment}-S3"
  role = "${aws_iam_role.codepipeline-deploy-ami.id}"
  policy = "${data.aws_iam_policy_document.codepipeline-deploy-ami-s3.json}"
}
