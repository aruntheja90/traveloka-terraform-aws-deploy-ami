resource "aws_codebuild_project" "deploy-ami-apply" {
    name         = "${var.service-name}-deploy-ami-${var.environment}-apply"
    description  = "Deploy ${var.service-name} AMI to ${var.environment}"
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
        buildspec = "buildspec-deployment-apply.yml"
    }

    tags {
        "ProductDomain" = "${var.product-domain}"
    }
}