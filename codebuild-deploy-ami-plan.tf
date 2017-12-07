resource "aws_codebuild_project" "deploy-ami-plan" {
    name         = "${local.env-plan-pipeline-name}"
    description  = "Plan ${var.service-name} AMI deployment to ${var.environment}"
    service_role = "${aws_iam_role.codebuild-deploy-ami.arn}"

    artifacts {
        type = "CODEPIPELINE"
        namespace_type = "BUILD_ID"
        packaging = "ZIP"
    }

    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image        = "aws/codebuild/ubuntu-base:14.04"
        type         = "LINUX_CONTAINER"
    }

    source {
        type     = "CODEPIPELINE"
        buildspec = "buildspec-deployment-plan.yml"
    }

    tags {
        "ProductDomain" = "${var.product-domain}"
    }
}